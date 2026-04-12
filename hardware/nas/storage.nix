{ ... }:

{
  fileSystems."/mnt/hdd" = {
    device = "/dev/disk/by-uuid/3ffcff12-4d4a-41ec-a391-20f66e7b18cd";
    fsType = "ext4";
  };
}
