{ pkgs, username, ... }:

{
  users.users.${username} = {
    isNormalUser = true;
    description = "Safiro Szperling";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
  };

  home-manager.users.${username} = ../home;
  home-manager.extraSpecialArgs = { inherit username; };

  programs.zsh.enable = true;
}