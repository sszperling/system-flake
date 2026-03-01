{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "sapph";
  home.homeDirectory = "/home/sapph";

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    bat
    git-crypt
    vscodium
    discord
    element-desktop
    telegram-desktop
    feishin
    zsh-powerlevel10k
    meslo-lgs-nf
  ];

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "25.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.firefox.enable = true;

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
        email = "zebaszp@example.com";
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
