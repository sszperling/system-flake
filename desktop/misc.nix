{ pkgs, ... }:

{
  home.packages = with pkgs; [
    blueman
    libnotify
    lxmenu-data
    networkmanagerapplet
    seahorse
    shared-mime-info
  ];

  xdg = {
    enable = true;
    userDirs.enable = true;
    userDirs.setSessionVariables = false; # 26.05
  };

  catppuccin.cursors = {
    enable = true;
    accent = "sapphire";
  };

  services = {
    blueman-applet.enable = true;
    network-manager-applet.enable = true;
    swaync.enable = true;
  };
}
