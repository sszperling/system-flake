{ pkgs, ... }:

{
  programs.hyprlock.enable = true;

  services.swayidle = {
    enable = true;
    events = {
      after-resume = "${pkgs.sway}/bin/swaymsg 'output * power on'";
      before-sleep = "${pkgs.hyprlock}/bin/hyprlock";
    };
    timeouts = [
      {
        timeout = 300;
        command = "${pkgs.sway}/bin/swaymsg 'output * power off' && ${pkgs.hyprlock}/bin/hyprlock";
        resumeCommand = "${pkgs.sway}/bin/swaymsg 'output * power on'";
      }
      {
        timeout = 600;
        command = "${pkgs.systemd}/bin/systemctl suspend";
      }
    ];
  };
}
