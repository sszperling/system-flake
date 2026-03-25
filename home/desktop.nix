{ lib, pkgs, username, homedir, ... }:

lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
  home.packages = with pkgs; [
    brightnessctl
    font-awesome
    grim
    imv
    libnotify
    nautilus
    networkmanagerapplet
    seahorse
    slurp
    swaybg
    wl-clipboard
    xdg-user-dirs
  ];

  catppuccin.cursors = {
    enable = true;
    accent = "sapphire";
  };
  home.pointerCursor = {
    sway.enable = true;
  };

  programs.waybar = {
    enable = true;
    settings = [{
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
        "custom/power"
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

      clock = {
        tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        format-alt = "{:%Y-%m-%d}";
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

      "custom/power" = {
        format  = "⏻ ";
        tooltip = false;
        menu = "on-click";
        menu-file = ./waybar-power-menu.xml;
        menu-actions = {
          shutdown = "shutdown";
          reboot = "reboot";
          suspend = "systemctl suspend";
          hibernate = "systemctl hibernate";
        };
      };
    }];
  };

  programs.rofi.enable = true;
  programs.swaylock.enable = true;

  services = {
    blueman-applet.enable = true;
    network-manager-applet.enable = true;
    mako.enable = true;

    swayidle = {
      enable = true;
      events = {
        after-resume = "swaymsg 'output * power on'";
        before-sleep = "${pkgs.swaylock}/bin/swaylock -fF";
      };
      timeouts = [
        { timeout = 300; command = "swaymsg 'output * power off' && ${pkgs.swaylock}/bin/swaylock -fF"; }
        { timeout = 600; command = "${pkgs.systemd}/bin/systemctl suspend"; }
      ];
    };
  };

  wayland.windowManager.sway = let ModKey = "Mod4"; in {
    enable = true;
    systemd = {
      enable = true;
      dbusImplementation = "broker";
    };
    package = pkgs.sway;
    wrapperFeatures.gtk = true; # Fixes common issues with GTK 3 apps
    config = {
      modifier = ModKey;
      terminal = "foot";
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
      };
      bars = [{
        command = "${pkgs.waybar}/bin/waybar";
      }];
      menu = "rofi -show drun";
      focus.followMouse = false;
      window = {
        titlebar = false;
        hideEdgeBorders = "smart_no_gaps";
      };
      keybindings = lib.mkOptionDefault {
        "${ModKey}+Tab" = "exec --no-startup-id rofi -show window";
        # Print screen
        Print = "exec --no-startup-id grim \"$(xdg-user-dir PICTURES)/Screenshots/$(date +%Y-%m-%d_%H-%M-%S).png\"";
        "Shift+Print" = "exec --no-startup-id grim -g \"$(slurp)\" \"$(xdg-user-dir PICTURES)/Screenshots/$(date +%Y-%m-%d_%H-%M-%S).png\"";
        "Control+Print" = "exec --no-startup-id grim - | wl-copy";
        "Control+Shift+Print" = "exec --no-startup-id grim -g \"$(slurp)\" - | wl-copy";
        # Brightness Controls
        XF86MonBrightnessDown = "exec brightnessctl set 10%-";
        XF86MonBrightnessUp = "exec brightnessctl set 10%+";
        # Volume Controls
        XF86AudioRaiseVolume = "exec wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+";
        XF86AudioLowerVolume = "exec wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%-";
        XF86AudioMute = "exec wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        XF86AudioMicMute = "exec wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
      };
    };
  };

  systemd.user.services = {
    nm-applet = {
      Unit = {
        Description = "NetworkManager applet in tray";
        After = "sway-session.target";
      };
      Service = {
        ExecStart = "${pkgs.networkmanagerapplet}/bin/nm-applet";
      };
    };
  };
}
