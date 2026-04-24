{ username, storageMount, config, containerLib, ... }:

let
  uid = config.users.users."${username}".uid;
  gid = config.users.groups."${username}".gid;
  tcpPort = "8096";
  udpPort = "7359";
  containerName = "gomon";
  networkName = "${containerName}_default";
  dataDir = containerLib.mkDataDir containerName;
in {
  virtualisation.oci-containers.containers."${containerName}" = {
    image = "jellyfin/jellyfin";
    environment = {
      "TP_COMMUNITY_THEME" = "true";
      "TP_THEME" = "catppuccin-mocha";
    };
    volumes = [
      "${storageMount}/media:/media:rw"
      "${dataDir}/service/cache:/cache:rw"
      "${dataDir}/service/config:/config:rw"
      "${dataDir}/theme-park/jellyfin/98-themepark:/etc/cont-init.d/98-themepark:rw"
    ];
    ports = [
      "${tcpPort}:${tcpPort}/tcp"
      "${udpPort}:${udpPort}/udp"
    ];
    user = "${builtins.toString uid}:${builtins.toString gid}";
    log-driver = "journald";
    extraOptions = [
      "--device=/dev/dri/renderD128:/dev/dri/renderD128:rwm"
      "--network-alias=${containerName}"
      "--network=${networkName}"
      "--security-opt=no-new-privileges:true"
    ];
  };
  
  systemd.services = containerLib.mkService.default containerName;
}