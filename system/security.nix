{ ... }:

{
  services = {
    howdy.enable = true;
    linux-enable-ir-emitter.enable = true;
  };

  security.pam.howdy = {
    enable = true;
    control = "sufficient";
  };

  services."06cb-009a-fingerprint-sensor" = {
    enable = true;
    backend = "libfprint-tod";
    calib-data-file = ./calib-data.bin;
  };
}