{ pkgs, username, homedir, ... }:

{
  users = {
    groups.${username} = {
      gid = 1000;
      members = [ username ];
    };
    users.${username} = {
      isNormalUser = true;
      description = "Safiro Szperling";
      uid = 1000;
      group = username;
      extraGroups = [ "networkmanager" "wheel" ];
      shell = pkgs.zsh;
    };
  };

  home-manager.users.${username} = {};
  home-manager.extraSpecialArgs = { inherit username homedir; };

  programs.zsh.enable = true;
}