{ ... }:

{
  services.printing.enable = true;

  services."06cb-009a-fingerprint-sensor" = {                                 
    enable = true;
    backend = "libfprint-tod";
    calib-data-file = ./calib-data.bin;
  };
}