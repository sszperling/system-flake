{ pkgs, username, ... }:

{
  home.packages = with pkgs; [
    ulauncher
  ];

  wayland.windowManager.sway.config = {
    startup = [{
      command = "${pkgs.ulauncher}/bin/ulauncher --hide-window";
      always = true;
    }];
    menu = "${pkgs.ulauncher}/bin/ulauncher-toggle";
    window.commands = [
      {
        command = "border none";
        criteria = { app_id = "ulauncher"; };
      }
    ];
  };
}
