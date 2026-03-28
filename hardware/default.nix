{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/mapper/luks-56570ee7-5fc5-4db5-9366-2e99a4ebeffc";
      fsType = "ext4";
    };

  boot.initrd.luks.devices."luks-56570ee7-5fc5-4db5-9366-2e99a4ebeffc".device = "/dev/disk/by-uuid/56570ee7-5fc5-4db5-9366-2e99a4ebeffc";
  boot.initrd.luks.devices."luks-c0e4319c-b6c0-4b16-bf5e-fabfed5f6277".device = "/dev/disk/by-uuid/c0e4319c-b6c0-4b16-bf5e-fabfed5f6277";

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/002D-188B";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

  swapDevices =
    [ { device = "/dev/mapper/luks-c0e4319c-b6c0-4b16-bf5e-fabfed5f6277"; }
    ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  hardware.bluetooth.enable = true;
}
