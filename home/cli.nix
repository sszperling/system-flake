{ config, pkgs, lib, ... }:

{
  fonts.fontconfig.enable = true;

  home = {
    packages = with pkgs; [
      file
      git-crypt
      htop
      httpie
      jq
      nerd-fonts.hack
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

    delta = {
      enable = true;
      enableGitIntegration = true;
    };

    ghostty = {
      enable = true;
      package = lib.mkIf pkgs.stdenv.hostPlatform.isMacOS pkgs.ghostty-bin;
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
    };
  };

  # messes up with the preset
  catppuccin.starship.enable = false;

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 1800;
    enableSshSupport = true;
  };
}