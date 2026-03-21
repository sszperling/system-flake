{ ... }:

{
  services = {
    howdy.enable = true;
    linux-enable-ir-emitter.enable = true;

    gnome.gnome-keyring.enable = true;

    "06cb-009a-fingerprint-sensor" = {
      enable = true;
      backend = "libfprint-tod";
      calib-data-file = ./calib-data.bin;
    };
  };

  security = {
    polkit.enable = true;
    pam = {
      howdy = {
        enable = true;
        control = "sufficient";
      };
      services.swaylock = {};
    };
  };
}