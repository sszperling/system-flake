{ pkgs, ... }:

{
  home.username = "sapph";
  home.homeDirectory = "/home/sapph";
  home.stateVersion = "25.11";
  programs.home-manager.enable = true;
}
