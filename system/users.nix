{ pkgs, username, ... }:

{
  users.users.${username} = {
    isNormalUser = true;
    description = "Safiro Szperling";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;
}