{ username, config, containerLib, ... }:

let
  uid = config.users.users."${username}".uid;
  gid = config.users.groups."${username}".gid;
  port = "9998";
  containerName = "ntfy";
  networkName = "${containerName}_default";
  dataDir = containerLib.mkDataDir containerName;
in {
  virtualisation.oci-containers.containers."${containerName}" = {
    image = "binwiederhier/ntfy";
    environment = {
      "TZ" = "Europe/Stockholm";
      "NTFY_BASE_URL" = "http://ntfy";
      "NTFY_BEHIND_PROXY" = "true";
      "NTFY_LISTEN_HTTP" = ":${port}";
      "NTFY_UPSTREAM_BASE_URL" = "https://ntfy.sh"; # for iOS push notif support
    };
    volumes = [
      "${dataDir}/cache:/var/cache/ntfy:rw"
      "${dataDir}/etc:/etc/ntfy:rw"
    ];
    ports = [
      "${port}:${port}/tcp"
    ];
    cmd = [ "serve" ];
    user = "${builtins.toString uid}:${builtins.toString gid}";
    log-driver = "journald";
    extraOptions = [
      "--cap-drop=NET_RAW"
      "--health-cmd=wget -q --tries=1 http://localhost:${port}/v1/health -O - | grep -Eo '\"healthy\"\\s*:\\s*true'"
      "--health-interval=1m0s"
      "--health-retries=3"
      "--health-start-period=40s"
      "--health-timeout=10s"
      "--network-alias=${containerName}"
      "--network=${networkName}"
      "--security-opt=no-new-privileges:true"
    ];
  };

  systemd.services = containerLib.mkService.default containerName;
}