{ /*username,*/ ... }:

{
  virtualisation.docker = {
    enable = true;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };
  # hopefully we can use rootless instead?
  # users.extraGroups.docker.members = [ username ];
}