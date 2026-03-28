{ lib, pkgs, username, homedir, ... }:

{
  home.packages = with pkgs; [
    swaybg
  ];

  home.pointerCursor.sway.enable = true;

  wayland.windowManager.sway = {
    enable = true;
    systemd = {
      enable = true;
      dbusImplementation = "broker";
    };
    wrapperFeatures.gtk = true; # Fixes common issues with GTK 3 apps
    config = {
      modifier = "Mod4";
      terminal = "${pkgs.ghostty}/bin/ghostty";
      input = {
        "*".xkb_layout = "se";
        "type:touchpad" = {
          tap = "enabled";
          natural_scroll = "enabled";
          dwt = "enabled";
        };
      };
      output = {
        "*" = {
          bg = "${./wallpaper.png} fill";
        };
        DP-1 = {
          scale = "1.5";
        };
      };
      focus.followMouse = false;
      window = {
        titlebar = false;
        hideEdgeBorders = "smart_no_gaps";
      };
    };
  };
}
