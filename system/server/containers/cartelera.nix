{ username, storageMount, config, containerLib, ... }:

let
  uid = config.users.users."${username}".uid;
  gid = config.users.groups."${username}".gid;
  port = "5055";
  containerName = "cartelera";
  networkName = "${containerName}_default";
  dataDir = containerLib.mkDataDir containerName;
in {
  virtualisation.oci-containers.containers."${containerName}" = {
    image = "ghcr.io/seerr-team/seerr";
    environment = {
      "LOG_LEVEL" = "debug";
      "TZ" = "Europe/Stockholm";
    };
    volumes = [
      "${dataDir}/config:/app/config:rw"
    ];
    ports = [
      "${port}:${port}/tcp"
    ];
    user = "${builtins.toString uid}:${builtins.toString gid}";
    log-driver = "journald";
    extraOptions = [
      "--health-cmd=wget --no-verbose --tries=1 --spider http://localhost:${port}/api/v1/settings/public"
      "--health-interval=30s"
      "--health-start-period=20s"
      "--health-timeout=5s"
      "--network-alias=${containerName}"
      "--network=${networkName}"
      "--security-opt=no-new-privileges:true"
    ];
  };
  
  systemd.services = containerLib.mkService.default containerName;
}