{ pkgs, ... }:

{
  home.packages = with pkgs; [
    font-awesome
  ];

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
        "group/hardware"
        "tray"
        "custom/notifcenter"
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

      "group/hardware" = {
        orientation = "inherit";
        modules = [
          "pulseaudio"
          "network"
          "battery"
          "clock"
        ];
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

      "custom/notifcenter" = {
        tooltip = true;
        format = "{icon}";
        format-icons = {
          notification = "󱅫";
          none = "󰂜";
          dnd-notification = "󰂠";
          dnd-none = "󰪓";
          inhibited-notification = "󰂛";
          inhibited-none = "󰪑";
          dnd-inhibited-notification = "󰂛";
          dnd-inhibited-none = "󰪑";
        };
        return-type = "json";
        exec = "${pkgs.swaynotificationcenter}/bin/swaync-client -swb";
        on-click = "${pkgs.swaynotificationcenter}/bin/swaync-client -t -sw";
        on-click-right = "${pkgs.swaynotificationcenter}/bin/swaync-client -d -sw";
        escape = true;
      };

      "custom/power" = {
        format  = "⏻";
        tooltip = false;
        menu = "on-click";
        menu-file = ./waybar/power-menu.xml;
        menu-actions = {
          shutdown = "${pkgs.systemd}/bin/systemctl poweroff";
          reboot = "${pkgs.systemd}/bin/systemctl reboot";
          suspend = "${pkgs.systemd}/bin/systemctl suspend";
          hibernate = "${pkgs.systemd}/bin/systemctl hibernate";
        };
      };
    }];
    style = builtins.readFile ./waybar/style.css;
  };
  wayland.windowManager.sway.config.bars = [{
    command = "${pkgs.waybar}/bin/waybar";
  }];
}
