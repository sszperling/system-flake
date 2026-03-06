{ config, pkgs, ... }:

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

    shellAliases = {
      ll = "ls -l";
      update = "sudo nixos-rebuild switch";
    };
    history.size = 10000;
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
      theme = "agnoster";
      extraConfig = "export DEFAULT_USER=${config.home.username}";
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