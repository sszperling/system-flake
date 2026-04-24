{ pkgs, lib, username, homedir, config, rootTarget, containerLib, ... }:

let
  uid = config.users.users."${username}".uid;
  gid = config.users.groups."${username}".gid;
  port = "8001";
  containerService = "docker-freshrss";
  networkName = "freshrss_default";
  networkService = "docker-network-${networkName}";
in {
  # Containers
  virtualisation.oci-containers.containers."freshrss" = {
    image = "freshrss/freshrss:latest";
    environment = {
      "CRON_MIN" = "3,33";
      "PGID" = builtins.toString uid;
      "PUID" = builtins.toString gid;
      "TZ" = "Europe/Stockholm";
      "LISTEN" = "0.0.0.0:${port}";
    };
    volumes = [
      "${homedir}/containers/freshrss/data:/var/www/FreshRSS/data:rw"
      "${homedir}/containers/freshrss/extensions:/var/www/FreshRSS/extensions:rw"
    ];
    ports = [
      "${port}:${port}/tcp"
    ];
    log-driver = "journald";
    extraOptions = [
      "--cap-drop=NET_RAW"
      "--health-cmd=php -r \"readfile('http://localhost:${port}/i/');\" | grep -q 'jsonVars'"
      "--health-interval=30s"
      "--health-retries=3"
      "--health-start-period=20s"
      "--health-timeout=5s"
      "--network-alias=freshrss"
      "--network=${networkName}"
      "--security-opt=no-new-privileges:true"
    ];
    serviceName = containerService;
  };
  systemd.services = {
    "${containerService}" = {
      serviceConfig = {
        Restart = lib.mkOverride 90 "always";
        RestartMaxDelaySec = lib.mkOverride 90 "1m";
        RestartSec = lib.mkOverride 90 "100ms";
        RestartSteps = lib.mkOverride 90 9;
      };
      after = [ "${networkService}.service" ];
      requires = [ "${networkService}.service" ];
      partOf = [ rootTarget ];
      wantedBy = [ rootTarget ];
    };
    "${networkService}" = containerLib.mkService.network networkName;
  };
}