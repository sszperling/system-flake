{ lib, username, storageMount, config, containerLib, rootTarget, ... }:

let
  uid = config.users.users."${username}".uid;
  gid = config.users.groups."${username}".gid;
  groupName = "the-bay";
  containerNames = {
    vpn = "${groupName}_vpn";
    client = "${groupName}_client";
    shows = "${groupName}_shows";
    movies = "${groupName}_movies";
    trackers = "${groupName}_trackers";
    flaresolverr = "${groupName}_flaresolverr";
  };
  serviceNames = lib.attrsets.mapAttrs (_: val: "docker-${val}") containerNames;
  ports = {
    clientTorrent = "6881";
    clientWebUI = "8080";
    trackers = "9696";
    shows = "8989";
    movies = "7878";
    flaresolverr = "8191";
  };
  networkName = "${groupName}_default";
  networkService = "docker-network-${networkName}";
  dataDir = containerLib.mkDataDir groupName;
in {
  virtualisation.oci-containers.containers = {
    "${containerNames.vpn}" = {
      image = "qmcgaw/gluetun";
      environment = {
        "SERVER_COUNTRIES" = "Sweden";
        "VPN_SERVICE_PROVIDER" = "nordvpn";
        "VPN_TYPE" = "wireguard";
      };
      environmentFiles = [
        config.age.secrets.vpn.path
      ];
      ports = [
        "${ports.trackers}:${ports.trackers}/tcp"
        "${ports.clientWebUI}:${ports.clientWebUI}/tcp"
        "${ports.shows}:${ports.shows}/tcp"
        "${ports.movies}:${ports.movies}/tcp"
      ];
      log-driver = "journald";
      extraOptions = [
        "--cap-add=NET_ADMIN"
        "--device=/dev/net/tun:/dev/net/tun:rwm"
        "--network-alias=torrent-vpn"
        "--network=${networkName}"
      ];
    };
    "${containerNames.client}" = {
      image = "ghcr.io/hotio/qbittorrent:release";
      environment = {
        "PGID" = builtins.toString uid;
        "PUID" = builtins.toString gid;
        "TORRENTING_PORT" = "${ports.clientTorrent}";
        "TP_COMMUNITY_THEME" = "true";
        "TP_HOTIO" = "true";
        "TP_THEME" = "catppuccin-mocha";
        "TZ" = "Europe/Stockholm";
        "WEBUI_PORT" = "${ports.clientWebUI}";
      };
      volumes = [
        "${storageMount}:/data:rw"
        "${dataDir}/qbittorrent/config:/config:rw"
        "${dataDir}/theme-park/qbittorrent/98-themepark:/etc/cont-init.d/98-themepark:rw"
      ];
      dependsOn = [ containerNames.vpn ];
      log-driver = "journald";
      extraOptions = [
        "--health-cmd=[[ \"$(curl -s -o /dev/null -w '%{http_code}' http://localhost:${ports.clientWebUI}/api/v2/app/version)\" == 200 ]]"
        "--health-interval=1m0s"
        "--health-retries=3"
        "--health-start-period=30s"
        "--health-timeout=10s"
        "--network=container:${containerNames.vpn}"
      ];
    };
    "${containerNames.trackers}" = {
      image = "ghcr.io/hotio/prowlarr:release";
      environment = {
        "PGID" = builtins.toString uid;
        "PUID" = builtins.toString gid;
        "TP_COMMUNITY_THEME" = "true";
        "TP_HOTIO" = "true";
        "TP_THEME" = "catppuccin-mocha";
        "TZ" = "Europe/Stockholm";
        "WEBUI_PORTS" = "${ports.trackers}/tcp";
      };
      volumes = [
        "${dataDir}/prowlarr/config:/config:rw"
        "${dataDir}/theme-park/prowlarr/98-themepark:/etc/cont-init.d/98-themepark:rw"
      ];
      dependsOn = [ containerNames.vpn ];
      log-driver = "journald";
      extraOptions = [
        "--health-cmd=curl -L http://localhost:${ports.trackers}/ping | grep OK"
        "--health-interval=1m0s"
        "--health-retries=3"
        "--health-start-period=30s"
        "--health-timeout=10s"
        "--network=container:${containerNames.vpn}"
      ];
    };
    "${containerNames.shows}" = {
      image = "ghcr.io/hotio/sonarr:release";
      environment = {
        "PGID" = builtins.toString uid;
        "PUID" = builtins.toString gid;
        "TP_COMMUNITY_THEME" = "true";
        "TP_HOTIO" = "true";
        "TP_THEME" = "catppuccin-mocha";
        "TZ" = "Europe/Stockholm";
      };
      volumes = [
        "${storageMount}:/data:rw"
        "${dataDir}/sonarr/config:/config:rw"
        "${dataDir}/theme-park/sonarr/98-themepark:/etc/cont-init.d/98-themepark:rw"
      ];
      dependsOn = [ containerNames.vpn ];
      log-driver = "journald";
      extraOptions = [
        "--health-cmd=curl -L http://localhost:${ports.shows}/ping | grep OK"
        "--health-interval=1m0s"
        "--health-retries=3"
        "--health-start-period=30s"
        "--health-timeout=10s"
        "--network=container:${containerNames.vpn}"
      ];
    };
    "${containerNames.movies}" = {
      image = "ghcr.io/hotio/radarr:release";
      environment = {
        "PGID" = builtins.toString uid;
        "PUID" = builtins.toString gid;
        "TP_COMMUNITY_THEME" = "true";
        "TP_HOTIO" = "true";
        "TP_THEME" = "catppuccin-mocha";
        "TZ" = "Europe/Stockholm";
      };
      volumes = [
        "${storageMount}:/data:rw"
        "${dataDir}/radarr/config:/config:rw"
        "${dataDir}/theme-park/radarr/98-themepark:/etc/cont-init.d/98-themepark:rw"
      ];
      dependsOn = [ containerNames.vpn ];
      log-driver = "journald";
      extraOptions = [
        "--health-cmd=curl -L http://localhost:${ports.movies}/ping | grep OK"
        "--health-interval=1m0s"
        "--health-retries=3"
        "--health-start-period=30s"
        "--health-timeout=10s"
        "--network=container:${containerNames.vpn}"
      ];
    };
    "${containerNames.flaresolverr}" = {
      image = "ghcr.io/flaresolverr/flaresolverr:latest";
      environment = {
        "CAPTCHA_SOLVER" = "none";
        "LOG_FILE" = "none";
        "LOG_HTML" = "false";
        "LOG_LEVEL" = "info";
        "TZ" = "Europe/Stockholm";
      };
      volumes = [
        "${dataDir}/flaresolverr/config:/config:rw"
      ];
      dependsOn = [ containerNames.vpn ];
      log-driver = "journald";
      extraOptions = [
        "--health-cmd=curl http://localhost:${ports.flaresolverr}/health | grep ok"
        "--health-interval=1m0s"
        "--health-retries=3"
        "--health-start-period=30s"
        "--health-timeout=10s"
        "--network=container:${containerNames.vpn}"
      ];
    };
  };

  systemd.services =
    let
      subService = {
        serviceConfig = containerLib.restartConfig.unlessStopped;
        partOf = [ rootTarget ];
        wantedBy = [ rootTarget ];
      };
    in {
      "${serviceNames.client}" = subService;
      "${serviceNames.flaresolverr}" = subService;
      "${serviceNames.movies}" = subService;
      "${serviceNames.shows}" = subService;
      "${serviceNames.trackers}" = subService;
      "${serviceNames.vpn}" = containerLib.mkService.container networkService;
      "${networkService}" = containerLib.mkService.network networkName;
    };
}