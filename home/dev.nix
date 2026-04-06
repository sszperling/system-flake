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
    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        jnoortheen.nix-ide
      ];
      enableUpdateCheck = false;
      userSettings = {
        "git.autofetch" = true;
        "editor.renderWhitespace" = "all";
        "git.allowForcePush" = true;
        "terminal.integrated.initialHint" = false;
        "editor.fontFamily" = "'Hack Nerd Font Mono','Font Awesome 7  Free','Droid Sans Mono', monospace";
      };
    };
  };
}
