{ pkgs, username, homedir, catppuccin, ... }:

{
  users.users.${username} = {
    isNormalUser = true;
    description = "Safiro Szperling";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
  };

  home-manager.users.${username} = {
    imports = [
      ../home
      catppuccin.homeModules.catppuccin
    ];
  };
  home-manager.extraSpecialArgs = { inherit username homedir; };

  programs.zsh.enable = true;
}