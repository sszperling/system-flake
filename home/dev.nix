{ pkgs, ... }:

{
  home.packages = with pkgs; [
    kotlin
    rustc
  ] ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux [
    android-studio # only provided for linux
    android-tools # no point in installing without the above
    gradle # no point in installing without the above
  ];

  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
  };
}
