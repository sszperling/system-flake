{ username, catppuccin, ... }:

{
  home-manager.users.${username} = {
    imports = [
      ../../home/base
      ../../home/server
      catppuccin.homeModules.catppuccin
    ];
  };
}