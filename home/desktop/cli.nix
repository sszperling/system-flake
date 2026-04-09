{ pkgs, lib, ... }:

{
  programs = {
    delta = {
      enable = true;
      enableGitIntegration = true;
    };

    ghostty = {
      enable = true;
      package = lib.mkIf pkgs.stdenv.hostPlatform.isMacOS pkgs.ghostty-bin;
    };
  };

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 1800;
    enableSshSupport = true;
  };
}