{ lib, pkgs, username, homedir, ... }:

lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
  home.packages = with pkgs; [
    font-awesome
    grim
    imv
    libnotify
    lxmenu-data
    networkmanagerapplet
    pcmanfm
    seahorse
    shared-mime-info
    slurp
    swaybg
    wl-clipboard
    xdg-user-dirs
    zathura
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

      "sway/workspaces" = {
         disable-scroll = true;
         sort-by-name = true;
         format = " {icon} ";
         format-icons = {
            default = "";
         };
      };

      battery = {
        states = {
          warning = 30;
          critical = 15;
        };
        format = "{icon} {capacity}%";
        format-full = "{icon} {capacity}%";
        format-charging = " {capacity}%";
        format-plugged = " {capacity}%";
        format-alt = "{icon} {time}";
        format-icons = ["" "" "" "" ""];
      };

      clock = {
        format = " {:%H:%M}";
        format-alt = " {:%d/%m/%Y}";
        tooltip-format = "<tt>{calendar}</tt>";
      };

      pulseaudio = {
        scroll-step = 5;
        format = "{icon} {volume}% {format_source}";
        format-bluetooth = "{icon} {volume}% {format_source}";
        format-bluetooth-muted = "{icon}  {format_source}";
        format-muted = " {format_source}";
        format-source = " {volume}%";
        format-source-muted = "";
        format-icons = {
          headphone = "";
          hands-free = "";
          headset = "";
          phone = "";
          portable = "";
          car = "";
          default = ["" "" "" ""];
        };
        on-click = "${pkgs.pwvucontrol}/bin/pwvucontrol";
      };

      network = {
        format-wifi = " {signalStrength}%";
        format-ethernet = " {ipaddr}/{cidr}";
        tooltip-format = " {ifname} via {gwaddr}";
        format-linked = " {ifname} (No IP)";
        format-disconnected = "⚠ Disconnected";
        format-alt = "{ifname}: {ipaddr}/{cidr}";
      };

      "custom/power" = {
        format  = "⏻";
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
    style = builtins.readFile ./waybar/style.css;
  };

  programs.vicinae = {
    enable = true;
    systemd.enable = true;
  };
  systemd.user.services.vicinae.Service.Environment = [
    "PATH=/etc/profiles/per-user/${username}/bin"
  ];

  programs.swaylock.enable = true;
  services.swayosd.enable = true;
  dbus.packages = [ pkgs.swayosd ];
  systemd.user.packages = [ pkgs.swayosd ];

  services = {
    blueman-applet.enable = true;
    network-manager-applet.enable = true;
    swaync.enable = true;

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
      terminal = "ghostty";
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
        DP-2 = {
          scale = "1.5";
        };
      };
      bars = [{
        command = "${pkgs.waybar}/bin/waybar";
      }];
      menu = "vicinae open";
      focus.followMouse = false;
      window = {
        titlebar = false;
        hideEdgeBorders = "smart_no_gaps";
      };
      keybindings = lib.mkOptionDefault {
        #"${ModKey}+Tab" = "exec --no-startup-id rofi -show window";
        # Print screen
        Print = "exec --no-startup-id grim \"$(xdg-user-dir PICTURES)/Screenshots/$(date +%Y-%m-%d_%H-%M-%S).png\"";
        "Shift+Print" = "exec --no-startup-id grim -g \"$(slurp)\" \"$(xdg-user-dir PICTURES)/Screenshots/$(date +%Y-%m-%d_%H-%M-%S).png\"";
        "Control+Print" = "exec --no-startup-id grim - | wl-copy";
        "Control+Shift+Print" = "exec --no-startup-id grim -g \"$(slurp)\" - | wl-copy";
        # Brightness Controls
        XF86MonBrightnessDown = "exec swayosd-client --brightness -10";
        XF86MonBrightnessUp = "exec swayosd-client --brightness +10";
        # Volume Controls
        XF86AudioRaiseVolume = "exec swayosd-client --output-volume raise";
        XF86AudioLowerVolume = "exec swayosd-client --output-volume lower";
        XF86AudioMute = "exec swayosd-client --output-volume mute-toggle";
        XF86AudioMicMute = "exec swayosd-client --input-volume mute-toggle";
        #"--release Caps_Lock" = "exec swayosd-client --caps-lock";
      };
    };
  };

  systemd.user.services = {
    nm-applet = {
      Unit = {
        Description = "NetworkManager applet in tray";
        PartOf = "sway-session.target";
        After = "sway-session.target";
      };
      Service = {
        ExecStart = "${pkgs.networkmanagerapplet}/bin/nm-applet";
        Restart = "on-failure";
      };
    };
    swayosd-libinput-backend = {
      Unit = {
        Description = "SwayOSD LibInput backend for listening to certain keys like CapsLock, ScrollLock, VolumeUp, etc.";
        Documentation = [ "https://github.com/ErikReider/SwayOSD" ];
        PartOf = "sway-session.target";
        After = "sway-session.target";
      };

      Service = {
        Type = "dbus";
        BusName = "org.erikreider.swayosd";
        ExecStart = "${pkgs.swayosd}/bin/swayosd-libinput-backend";
        Restart = "on-failure";
      };
    };
  };
}
