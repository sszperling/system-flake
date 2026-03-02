{ config, pkgs, ... }:

{
  imports = [
    ./base.nix
    ./boot.nix
    ./desktop.nix
    ./locale.nix
    ./misc.nix
    ./networking.nix
    ./sound.nix
    ./users.nix
  ];
}
