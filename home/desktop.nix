{ lib, pkgs, username, homedir, ... }:

lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
  home.packages = with pkgs; [
    brightnessctl
    font-awesome
    nautilus
    networkmanagerapplet
    rofi
    seahorse
  ];

  home.pointerCursor = {
    name = "Adwaita";
    package = pkgs.adwaita-icon-theme;
    size = 24;
    sway.enable = true;
  };

  programs.waybar.enable = true;
  programs.waybar.settings = [{
      spacing = 0;
      modules-left = [
        "sway/workspaces"
        "sway/mode"
      ];
      modules-center = [
        "sway/window"
      ];
      modules-right = [
        "pulseaudio"
        "network"
        "battery"
        "clock"
        "tray"
      ];
      tray.spacing = 10;
      
      battery = {
        states = {
          warning = 30;
          critical = 15;
        };
        format = "{capacity}% {icon}";
        format-full = "{capacity}% {icon}";
        format-charging = "{capacity}% ";
        format-plugged = "{capacity}% ";
        format-alt = "{time} {icon}";
        format-icons = ["" "" "" "" ""];
      };

      pulseaudio = {
        scroll-step = 5;
        format = "{volume}% {icon} {format_source}";
        format-bluetooth = "{volume}% {icon} {format_source}";
        format-bluetooth-muted = " {icon} {format_source}";
        format-muted = " {format_source}";
        format-source = "{volume}% ";
        format-source-muted = "";
        format-icons = {
          headphone = "";
          hands-free = "";
          headset = "";
          phone = "";
          portable = "";
          car = "";
          default = ["" "" ""];
        };
        on-click = "${pkgs.pwvucontrol}/bin/pwvucontrol";
      };
      network = {
        format-wifi = "{signalStrength}% ";
        format-ethernet = "{ipaddr}/{cidr} ";
        tooltip-format = "{ifname} via {gwaddr} ";
        format-linked = "{ifname} (No IP) ";
        format-disconnected = "Disconnected ⚠";
        format-alt = "{ifname}: {ipaddr}/{cidr}";
      };
  }];

  wayland.windowManager.sway = let ModKey = "Mod4"; in {
    enable = true;
    systemd.enable = true;
    package = pkgs.sway;
    wrapperFeatures.gtk = true; # Fixes common issues with GTK 3 apps
    config = {
      modifier = ModKey;
      terminal = "kitty";
      input = {
        "*".xkb_layout = "se";
        "type:touchpad" = {
          tap = "enabled";
          natural_scroll = "enabled";
          dwt = "enabled";
        };
      };
      bars = [{
        command = "${pkgs.waybar}/bin/waybar";
      }];
      keybindings = lib.mkOptionDefault {
        "${ModKey}+d" = "exec --no-startup-id rofi -show run";
        "${ModKey}+Tab" = "exec --no-startup-id rofi -show window";
        # Brightness Controls
        "XF86MonBrightnessDown" = "exec brightnessctl set 10%-";
        "XF86MonBrightnessUp" = "exec brightnessctl set 10%+";
        # Volume Controls
        "XF86AudioRaiseVolume" = "exec wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+";
        "XF86AudioLowerVolume" = "exec wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%-";
        "XF86AudioMute" = "exec wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        "XF86AudioMicMute" = "exec wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
      };
    };
  };
}
