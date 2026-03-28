{ pkgs, username, homedir, ... }:

{
  home = {
    inherit username;
    homeDirectory = homedir;
    stateVersion = "25.11";
  };

  programs.home-manager.enable = true;

  catppuccin = {
    enable = true;
    flavor = "mocha";
    accent = "sapphire";
  };
}
