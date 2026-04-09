{
  description = "Sapph's Frosted Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    fingerprint = {
      url = "github:elvetemedve/nixos-06cb-009a-fingerprint-sensor?ref=make-compatible-with-nixos-unstable-and-upgrade";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, catppuccin, ... }@inputs: {
    nixosConfigurations.nixpad =
      let
        hostname = "nixpad";
        username = "sapph";
        homedir = "/home/${username}";
      in nixpkgs.lib.nixosSystem {
        modules = with inputs; [
          ./hardware/thinkpad
          ./system/base
          ./system/desktop
          catppuccin.nixosModules.catppuccin
          nixos-hardware.nixosModules.lenovo-thinkpad-x280
          fingerprint.nixosModules."06cb-009a-fingerprint-sensor"
          home-manager.nixosModules.home-manager
        ];
        specialArgs = { inherit hostname username homedir catppuccin; };
      };

    homeConfigurations.safiros =
      let
        username = "safiros";
        homedir = "/Users/${username}";
      in home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          config = { allowUnfree = true; };
          system = "aarch64-darwin";
        };
        modules = with inputs; [
          ./home/base
          ./home/desktop
          catppuccin.homeModules.catppuccin
        ];
        extraSpecialArgs = { inherit username homedir; };
      };
  };
}

