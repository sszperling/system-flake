{ lib, username, homedir, config, rootTarget, containerLib, ... }:

let
  uid = config.users.users."${username}".uid;
  gid = config.users.groups."${username}".gid;
  port = "9998";
  containerService = "docker-ntfy";
  networkName = "ntfy_default";
  networkService = "docker-network-${networkName}";
in {
  # Containers
  virtualisation.oci-containers.containers."ntfy" = {
    image = "binwiederhier/ntfy";
    environment = {
      "TZ" = "Europe/Stockholm";
      "NTFY_BASE_URL" = "http://ntfy";
      "NTFY_BEHIND_PROXY" = "true";
      "NTFY_LISTEN_HTTP" = ":${port}";
      "NTFY_UPSTREAM_BASE_URL" = "https://ntfy.sh"; # for iOS push notif support
    };
    volumes = [
      "${homedir}/containers/ntfy/cache:/var/cache/ntfy:rw"
      "${homedir}/containers/ntfy/etc:/etc/ntfy:rw"
    ];
    ports = [
      "${port}:${port}/tcp"
    ];
    cmd = [ "serve" ];
    user = "${builtins.toString uid}:${builtins.toString gid}";
    log-driver = "journald";
    extraOptions = [
      "--health-cmd=wget -q --tries=1 http://localhost:${port}/v1/health -O - | grep -Eo '\"healthy\"\\s*:\\s*true'"
      "--health-interval=1m0s"
      "--health-retries=3"
      "--health-start-period=40s"
      "--health-timeout=10s"
      "--network-alias=ntfy"
      "--network=ntfy_default"
    ];
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