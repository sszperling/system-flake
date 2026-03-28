{ pkgs, ... }:

{
  programs.swaylock.enable = true;

  services.swayidle = {
    enable = true;
    events = {
      after-resume = "${pkgs.sway}/bin/swaymsg 'output * power on'";
      before-sleep = "${pkgs.swaylock}/bin/swaylock -fF";
    };
    timeouts = [
      { timeout = 300; command = "${pkgs.sway}/bin/swaymsg 'output * power off' && ${pkgs.swaylock}/bin/swaylock -fF"; }
      { timeout = 600; command = "${pkgs.systemd}/bin/systemctl suspend"; }
    ];
  };
}
