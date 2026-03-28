{ pkgs, ... }:

{
  # these apps only make sense in the context of an empty DE
  home.packages = with pkgs; [
    pcmanfm
  ];

  programs = {
    imv.enable = true;
    zathura.enable = true;
  };
}
