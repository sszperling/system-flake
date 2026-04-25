{ lib, username, storageMount, config, containerLib, rootTarget, ... }:

let
  uid = config.users.users."${username}".uid;
  gid = config.users.groups."${username}".gid;
  groupName = "immich";
  containerNames = {
    server = "${groupName}_server";
    ml = "${groupName}_machine_learning";
    redis = "${groupName}_redis";
    db = "${groupName}_postgres";
  };
  serviceNames = lib.attrsets.mapAttrs (_: val: "docker-${val}") containerNames;
  port = "2283";
  networkName = "${groupName}_default";
  networkService = "docker-network-${networkName}";
  dataDir = containerLib.mkDataDir groupName;
  immichVersion = "v2";
in {
  # Containers
  virtualisation.oci-containers.containers = {
    "${containerNames.ml}" = {
      image = "ghcr.io/immich-app/immich-machine-learning:${immichVersion}";
      environment = {
        "GUNICORN_CMD_ARGS" = "--no-control-socket";
        "IMMICH_HELMET_FILE" = "/data/helmet.json";
        "TZ" = "Europe/Stockholm";
      };
      environmentFiles = [
        config.age.secrets.immich.path
      ];
      volumes = [
        "${dataDir}/ml/.cache:/.cache:rw"
        "${dataDir}/ml/.config:/.config:rw"
        "${dataDir}/ml/cache:/cache:rw"
      ];
      user = "${builtins.toString uid}:${builtins.toString gid}";
      log-driver = "journald";
      extraOptions = [
        "--cap-drop=NET_RAW"
        "--device=/dev/dri:/dev/dri:rwm"
        "--device=/dev/kfd:/dev/kfd:rwm"
        "--group-add=${builtins.toString config.users.groups.video.gid}"
        "--network-alias=immich-machine-learning"
        "--network=${networkName}"
        "--security-opt=no-new-privileges:true"
      ];
      labels = {
        "dev.dozzle.group" = groupName;
      };
    };
    "${containerNames.db}" = {
      image = "ghcr.io/immich-app/postgres:14-vectorchord0.4.3-pgvectors0.2.0@sha256:bcf63357191b76a916ae5eb93464d65c07511da41e3bf7a8416db519b40b1c23";
      environment = {
        "POSTGRES_INITDB_ARGS" = "--data-checksums";
      };
      environmentFiles = [
        config.age.secrets.immich.path
      ];
      volumes = [
        "${dataDir}/db:/var/lib/postgresql/data:rw"
      ];
      user = "${builtins.toString uid}:${builtins.toString gid}";
      log-driver = "journald";
      extraOptions = [
        "--cap-drop=NET_RAW"
        "--health-cmd=pg_isready --dbname=$POSTGRES_DB --username=$POSTGRES_USER && [ \"$(psql --dbname=$POSTGRES_DB --username=$POSTGRES_USER --tuples-only --no-align --command='SELECT SUM(checksum_failures) FROM pg_stat_database')\" = '0' ]"
        "--health-interval=5m0s"
        "--health-start-period=5s"
        "--network-alias=database"
        "--network=${networkName}"
        "--security-opt=no-new-privileges:true"
        "--shm-size=134217728"
      ];
      labels = {
        "dev.dozzle.group" = groupName;
      };
    };
    "${containerNames.redis}" = {
      image = "docker.io/valkey/valkey:9@sha256:3b55fbaa0cd93cf0d9d961f405e4dfcc70efe325e2d84da207a0a8e6d8fde4f9";
      volumes = [
        "${dataDir}/redis:/data:rw"
      ];
      user = "${builtins.toString uid}:${builtins.toString gid}";
      log-driver = "journald";
      extraOptions = [
        "--cap-drop=NET_RAW"
        "--health-cmd=redis-cli ping || exit 1"
        "--network-alias=redis"
        "--network=${networkName}"
        "--security-opt=no-new-privileges:true"
      ];
      labels = {
        "dev.dozzle.group" = groupName;
      };
    };
    "${containerNames.server}" = {
      image = "ghcr.io/immich-app/immich-server:${immichVersion}";
      environment = {
        "GUNICORN_CMD_ARGS" = "--no-control-socket";
        "IMMICH_HELMET_FILE" = "/data/helmet.json";
        "TZ" = "Europe/Stockholm";
      };
      environmentFiles = [
        config.age.secrets.immich.path
      ];
      volumes = [
        "/etc/localtime:/etc/localtime:ro"
        "${storageMount}/photos:/data:rw"
        "${dataDir}/encoded-video:/data/encoded-video:rw"
        "${dataDir}/thumbs:/data/thumbs:rw"
      ];
      ports = [
        "${port}:${port}/tcp"
      ];
      dependsOn = [
        containerNames.db
        containerNames.redis
      ];
      user = "${builtins.toString uid}:${builtins.toString gid}";
      log-driver = "journald";
      extraOptions = [
        "--cap-drop=NET_RAW"
        "--device=/dev/dri:/dev/dri:rwm"
        "--network-alias=immich-server"
        "--network=${networkName}"
        "--security-opt=no-new-privileges:true"
      ];
      labels = {
        "dev.dozzle.group" = groupName;
      };
    };
  };

  systemd.services = 
    let
      serviceConfig = containerLib.mkService.container networkService;
    in {
      "${serviceNames.server}" = serviceConfig;
      "${serviceNames.ml}" = serviceConfig;
      "${serviceNames.redis}" = serviceConfig;
      "${serviceNames.db}" = serviceConfig;
      "${networkService}" = containerLib.mkService.network networkName;
    };
}