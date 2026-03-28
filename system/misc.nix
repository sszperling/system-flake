{ ... }:

{
  programs.dconf.enable = true;
  services.printing.enable = true;
  services.dbus.implementation = "broker";
}