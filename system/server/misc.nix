{ ... }:

{
  services = {
    # keep firmware up2d8
    fwupd.enable = true;

    # gotta migrate to zfs first
    # zfs.autoScrub.enable = true;
  };
}