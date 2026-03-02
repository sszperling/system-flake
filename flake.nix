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

  outputs = { self, nixpkgs, home-manager, nixos-hardware, fingerprint, ... }@inputs: {
    nixosConfigurations.nixpad = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./hardware
        ./system
	      nixos-hardware.nixosModules.lenovo-thinkpad-x280
	      fingerprint.nixosModules."06cb-009a-fingerprint-sensor"
        home-manager.nixosModules.home-manager
	      {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.sapph = ./home;
	      }
      ];
    };
  };
}

