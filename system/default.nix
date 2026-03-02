{ config, pkgs, ... }:

{
  imports = [
    ./base.nix
    ./boot.nix
    ./desktop.nix
    ./locale.nix
    ./misc.nix
    ./networking.nix
    ./security.nix
    ./sound.nix
    ./users.nix
  ];
}
