{
  description = "Sapph's Frosted Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    fingerprint = {
      url = "github:elvetemedve/nixos-06cb-009a-fingerprint-sensor?ref=make-compatible-with-nixos-unstable-and-upgrade";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations.nixpad =
      let
        username = "sapph";
        homedir = "/home/${username}";
      in nixpkgs.lib.nixosSystem {
        modules = with inputs; [
          ./hardware
          ./system
          nixos-hardware.nixosModules.lenovo-thinkpad-x280
          fingerprint.nixosModules."06cb-009a-fingerprint-sensor"
          home-manager.nixosModules.home-manager
        ];
        specialArgs = { inherit username homedir; };
      };
  };
}

