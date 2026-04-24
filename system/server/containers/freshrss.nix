{ username, config, containerLib, ... }:

let
  uid = config.users.users."${username}".uid;
  gid = config.users.groups."${username}".gid;
  port = "8001";
  containerName = "freshrss";
  networkName = "${containerName}_default";
  dataDir = containerLib.mkDataDir containerName;
in {
  virtualisation.oci-containers.containers."${containerName}" = {
    image = "freshrss/freshrss:latest";
    environment = {
      "CRON_MIN" = "3,33";
      "PGID" = builtins.toString uid;
      "PUID" = builtins.toString gid;
      "TZ" = "Europe/Stockholm";
      "LISTEN" = "0.0.0.0:${port}";
    };
    volumes = [
      "${dataDir}/data:/var/www/FreshRSS/data:rw"
      "${dataDir}/extensions:/var/www/FreshRSS/extensions:rw"
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
      "--network-alias=${containerName}"
      "--network=${networkName}"
      "--security-opt=no-new-privileges:true"
    ];
  };

  systemd.services = containerLib.mkService.default containerName;
}