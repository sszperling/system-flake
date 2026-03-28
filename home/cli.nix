{ config, pkgs, lib, ... }:

{
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    fastfetch
    git-crypt
    htop
    httpie
    jq
    nerd-fonts.hack
  ];

  programs.bat.enable = true;
  programs.broot.enable = true;
  programs.eza.enable = true;

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
  };

  programs.ghostty = {
    enable = true;
    package = lib.mkIf pkgs.stdenv.hostPlatform.isMacOS pkgs.ghostty-bin;
  };

  home.shell.enableZshIntegration = true;
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    oh-my-zsh = {
      enable = true;
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
    vimAlias = true;
    vimdiffAlias = true;
  };

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 1800;
    enableSshSupport = true;
  };
}