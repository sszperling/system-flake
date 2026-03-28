{ pkgs, ... }:

{
  # these apps only make sense in the context of an empty DE
  home.packages = with pkgs; [
    imv
    pcmanfm
    zathura
  ];
}
