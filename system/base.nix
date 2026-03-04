{ ... }:

{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.optimise.automatic = true;
  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "25.11";
}