{ pkgs, ... }:

{
  home.packages = with pkgs; [
    discord
    signal-desktop
  ] ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux [
    telegram-desktop # use mac specific version instead
    whatsapp-electron # not provided for mac, use specific version instead
  ] ++ lib.optionals pkgs.stdenv.hostPlatform.isMacOS [
    # whatsapp-for-mac # broken
  ];

  programs.element-desktop.enable = pkgs.stdenv.hostPlatform.isLinux; # does not build on mac
}