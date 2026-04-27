{ pkgs, ... }:

{
  home.packages = with pkgs; [
    feishin
    ffmpeg
    imagemagick
    inkscape
    yt-dlp
  ] ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux [
    vlc # not provided for mac, use bin instead
    gimp # not provided for mac
    jellyfin-desktop # broken on mac
  ] ++ lib.optionals pkgs.stdenv.hostPlatform.isMacOS [
    vlc-bin
  ];
}
