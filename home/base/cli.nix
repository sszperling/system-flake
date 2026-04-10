{ config, pkgs, lib, ... }:

{
  home = {
    packages = with pkgs; [
      file
      git-crypt
      htop
      httpie
      jq
    ];
   shell.enableZshIntegration = true;
  };

  programs = {
    atuin.enable = true;
    fastfetch.enable = true;
    bat.enable = true;
    broot.enable = true;
    eza.enable = true;

    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };

    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      dotDir = lib.mkIf pkgs.stdenv.hostPlatform.isLinux "${config.xdg.configHome}/zsh"; # 26.05
      defaultKeymap = "emacs";
    };

    starship = {
      enable = true;
      settings.username.show_always = false;
      presets = ["catppuccin-powerline"];
    };

    git = {
      enable = true;
      settings = {
        user = {
          name  = "Safiro Szperling";
          email = "zebaszp@gmail.com";
        };
        init.defaultBranch = "main";
        alias = {
          co = "checkout";
          st = "status";
        };
      };
    };

    neovim = {
      enable = true;
      defaultEditor = true;
      vimAlias = true;
      vimdiffAlias = true;
      withRuby = false; # 26.05
      withPython3 = false; # 26.05
    };
  };

  # messes up with the preset
  catppuccin.starship.enable = false;
}