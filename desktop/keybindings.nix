{ lib, pkgs, ... }:

{
  xdg.userDirs.enable = true;

  catppuccin.cursors = {
    enable = true;
    accent = "sapphire";
  };

  services = {
    swayosd.enable = true;
  };

  wayland.windowManager.sway.config.keybindings = lib.mkOptionDefault {
    # Print screen
    Print = "exec ${pkgs.grim}/bin/grim \"$(${pkgs.xdg-user-dirs}/bin/xdg-user-dir PICTURES)/Screenshots/$(date +%Y-%m-%d_%H-%M-%S).png\"";
    "Shift+Print" = "exec ${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp)\" \"$(${pkgs.xdg-user-dirs}/bin/xdg-user-dir PICTURES)/Screenshots/$(date +%Y-%m-%d_%H-%M-%S).png\"";
    "Control+Print" = "exec ${pkgs.grim}/bin/grim - | ${pkgs.wl-clipboard}/bin/wl-copy";
    "Control+Shift+Print" = "exec ${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp)\" - | ${pkgs.wl-clipboard}/bin/wl-copy";
    # Brightness Controls
    XF86MonBrightnessDown = "exec ${pkgs.swayosd}/bin/swayosd-client --brightness -10";
    XF86MonBrightnessUp = "exec ${pkgs.swayosd}/bin/swayosd-client --brightness +10";
    # Volume Controls
    XF86AudioRaiseVolume = "exec ${pkgs.swayosd}/bin/swayosd-client --output-volume raise";
    XF86AudioLowerVolume = "exec ${pkgs.swayosd}/bin/swayosd-client --output-volume lower";
    XF86AudioMute = "exec ${pkgs.swayosd}/bin/swayosd-client --output-volume mute-toggle";
    XF86AudioMicMute = "exec ${pkgs.swayosd}/bin/swayosd-client --input-volume mute-toggle";
  };
}
