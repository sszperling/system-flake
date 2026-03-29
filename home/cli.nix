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
      dotDir = "${config.xdg.configHome}/zsh"; # 26.05

      oh-my-zsh = {
        enable = true;
        theme = "agnoster";
        extraConfig = "export DEFAULT_USER=${config.home.username}";
      };
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

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 1800;
    enableSshSupport = true;
  };
}