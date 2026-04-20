{ username, rootTarget ... }:

{
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