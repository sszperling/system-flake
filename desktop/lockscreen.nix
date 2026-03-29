{ pkgs, ... }:

{
  programs.hyprlock.enable = true;

  services.hypridle = {
    enable = true;
    settings = {
        general = {
        after_sleep_cmd = "${pkgs.sway}/bin/swaymsg 'output * power on'";
        lock_cmd = "${pkgs.hyprlock}/bin/hyprlock";
      };

      listener = [
        {
          timeout = 300;
          on-timeout = "${pkgs.sway}/bin/swaymsg 'output * power off' && ${pkgs.hyprlock}/bin/hyprlock";
          on-resume = "${pkgs.sway}/bin/swaymsg 'output * power on'";
        }
        {
          timeout = 600;
          on-timeout = "${pkgs.systemd}/bin/systemctl suspend";
        }
      ];
    };
  };
}
