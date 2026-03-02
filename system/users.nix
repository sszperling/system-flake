{ pkgs, ... }:

{
  users.users.sapph = {
    isNormalUser = true;
    description = "Safiro Szperling";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;
}