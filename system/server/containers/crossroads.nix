{ username, config, containerLib, ... }:

let
  uid = config.users.users."${username}".uid;
  gid = config.users.groups."${username}".gid;
  containerName = "crossroads";
  networkName = "${containerName}_default";
  dataDir = containerLib.mkDataDir containerName;
in {
  virtualisation.oci-containers.containers."${containerName}" = {
    image = "jc21/nginx-proxy-manager:latest";
    environment = {
      "PGID" = builtins.toString uid;
      "PUID" = builtins.toString gid;
      "TP_COMMUNITY_THEME" = "true";
      "TP_THEME" = "catppuccin-mocha";
      "TZ" = "\"Europe/Stockholm\"";
    };
    volumes = [
      "${dataDir}/data:/data:rw"
      "${dataDir}/letsencrypt:/etc/letsencrypt:rw"
      "${./theme-park/nginx-proxy-manager/98-themepark}:/etc/cont-init.d/98-themepark:rw"
    ];
    ports = [
      "80:80/tcp"
      "81:81/tcp"
      "443:443/tcp"
    ];
    log-driver = "journald";
    extraOptions = [
      "--health-cmd=/usr/bin/check-health"
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