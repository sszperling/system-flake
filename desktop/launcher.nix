{ pkgs, username, ... }:

{
  home.packages = with pkgs; [
    ulauncher
  ];

  systemd.user.services.ulauncher = {
    Unit = {
      Description = "Linux Application Launcher";
      Documentation = "https://ulauncher.io/";
    };
    Service = {
      Type = "simple";
      Restart = "always";
      RestartSec = 1;
      ExecStart = "${pkgs.ulauncher}/bin/ulauncher --hide-window";
      Environment = [
        "PATH=/etc/profiles/per-user/${username}/bin"
      ];
    };
    Install = {
      WantedBy = ["graphical-session.target"];
    };
  };

  wayland.windowManager.sway.config = {
    menu = "${pkgs.ulauncher}/bin/ulauncher-toggle";
    window.commands = [
      {
        command = "border none";
        criteria = { app_id = "ulauncher"; };
      }
    ];
  };
}
