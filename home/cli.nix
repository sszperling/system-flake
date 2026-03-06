{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    bat
    git-crypt
    httpie
    jq
    meslo-lgs-nf
    tree
    zsh-powerlevel10k
  ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    plugins = [
      {
        name = "powerlevel10k-config";
        src = ./p10k;
        file = "p10k.zsh";
      }
      {
        name = "zsh-powerlevel10k";
        src = "${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/";
        file = "powerlevel10k.zsh-theme";
      }
    ];

    initContent = lib.mkBefore ''
      if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
        source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
      fi
    '';

    shellAliases = {
      ll = "ls -l";
    };
  };

  programs.git = {
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

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 1800;
    enableSshSupport = true;
  };
}