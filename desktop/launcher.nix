{ pkgs, username, ... }:

{
  programs.vicinae = {
    enable = true;
    systemd.enable = true;
  };

  # hack to fix not being able to launch due to missing path
  systemd.user.services.vicinae.Service.Environment = [
    "PATH=/etc/profiles/per-user/${username}/bin"
  ];

  wayland.windowManager.sway.config.menu = "${pkgs.vicinae}/bin/vicinae open";
}
