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
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs = { self, nixpkgs, home-manager, catppuccin, agenix, ... }@inputs: {
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
          nix-index-database.nixosModules.default
          { programs.nix-index-database.comma.enable = true; }
        ];
        specialArgs = { inherit hostname username homedir catppuccin; };
      };

    nixosConfigurations.nixstar =
      let
        hostname = "nixstar";
        username = "sapph";
        homedir = "/home/${username}";
        storageMount = "/mnt/hdd";
      in nixpkgs.lib.nixosSystem {
        modules = with inputs; [
          ./hardware/nas
          ./system/base
          ./system/server
          catppuccin.nixosModules.catppuccin
          agenix.nixosModules.default
          home-manager.nixosModules.home-manager
          nix-index-database.nixosModules.default
          { programs.nix-index-database.comma.enable = true; }
        ];
        specialArgs = { inherit hostname username homedir catppuccin agenix storageMount; };
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
          nix-index-database.homeModules.default
          { programs.nix-index-database.comma.enable = true; }
        ];
        extraSpecialArgs = { inherit username homedir agenix; };
      };
  };
}

