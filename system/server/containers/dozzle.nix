{ lib, username, homedir, config, rootTarget, containerLib, ... }:

let
  uid = config.users.users."${username}".uid;
  gid = config.users.groups."${username}".gid;
  port = "9999";
  containerService = "docker-dozzle";
  networkName = "dozzle_default";
  networkService = "docker-network-${networkName}";
in {
  # Containers
  virtualisation.oci-containers.containers."dozzle" = {
    image = "amir20/dozzle:latest";
    environment = {
      "TZ" = "Europe/Stockholm";
      "DOZZLE_ADDR" = ":${port}";
    };
    volumes = [
      "${homedir}/containers/dozzle/data:/data:rw"
      "/var/run/docker.sock:/var/run/docker.sock:rw"
    ];
    ports = [
      "${port}:${port}/tcp"
    ];
    log-driver = "journald";
    extraOptions = [
      "--cap-drop=NET_RAW"
      # broken docker stuff
      # "--health-cmd=[\"/dozzle\", \"healthcheck\"]"
      # "--health-interval=30s"
      # "--health-retries=5"
      # "--health-start-period=30s"
      # "--health-timeout=30s"
      "--network-alias=dozzle"
      "--network=${networkName}"
      "--security-opt=no-new-privileges:true"
    ];
  };

  systemd.services = {
    "${containerService}" = {
      serviceConfig = {
        Restart = lib.mkOverride 90 "no";
      };
      after = [ "${networkService}.service" ];
      requires = [ "${networkService}.service" ];
      partOf = [ rootTarget ];
      wantedBy = [ rootTarget ];
    };
    "${networkService}" = containerLib.mkService.network networkName;
  };
}