{ pkgs, ... }:

{
  home.packages = with pkgs; [
    libnotify
    lxmenu-data
    seahorse
    shared-mime-info
  ];

  xdg = {
    enable = true;
    userDirs.enable = true;
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
