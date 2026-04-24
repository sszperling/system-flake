{ pkgs, username, ... }@args:

let
  rootTarget = "docker-compose-root";
  libArgs = (args // { rootTarget = "${rootTarget}.target"; });
  containerLib = (import ./utils.nix libArgs);
  containerArgs = libArgs // { inherit containerLib; };
in {
  imports = [
    (import ./crossroads.nix containerArgs)
    (import ./dozzle.nix containerArgs)
    (import ./freshrss.nix containerArgs)
    (import ./gomon.nix containerArgs)
    (import ./ntfy.nix containerArgs)
    (import ./the-bay.nix containerArgs)
  ];

  virtualisation = {
    docker = {
      enable = true;
      autoPrune.enable = true;
    };
    oci-containers.backend = "docker";
  };
  users.extraGroups.docker.members = [ username ];

  # Root service
  # When started, this will automatically create all resources and start
  # the containers. When stopped, this will teardown all resources.
  systemd.targets."${rootTarget}" = {
    unitConfig = {
      Description = "Root target for all Compose-based services";
    };
    wantedBy = [ "multi-user.target" ];
  };
}