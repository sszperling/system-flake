{ pkgs, ... }:

{
  home.packages = with pkgs; [
    discord
    element-desktop
    telegram-desktop
  ];
}