{ username, homedir, ... }:

{
  home = {
    inherit username;
    homeDirectory = homedir;
    stateVersion = "25.11";
  };

  programs = {
    home-manager.enable = true;

    nh = {
      enable = true;
      flake = "${homedir}/system-flake";
    };
  };
}
