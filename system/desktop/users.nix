{ username, catppuccin, ... }:

{
  home-manager.users.${username} = {
    imports = [
      ../../home/base
      ../../home/desktop
      ../../desktop
      catppuccin.homeModules.catppuccin
    ];
  };
}