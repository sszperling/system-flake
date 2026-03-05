{ pkgs, ... }:

{
  home.packages = with pkgs; [
    discord
  ] ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux [
    element-desktop # does not build on mac
    telegram-desktop # use mac specific version instead
  ];
}