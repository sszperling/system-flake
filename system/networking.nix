{ ... }:

{
  networking.hostName = "nixpad";
  networking.networkmanager.enable = true;

  services.tailscale.enable = true;
}