{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "thunderbolt" "usb_storage" "usbhid" "sd_mod" "rtsx_pci_sdmmc" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/mapper/luks-8f66deac-1b0e-453d-a672-0b7c555df525";
      fsType = "ext4";
    };

  boot.initrd.luks.devices."luks-8f66deac-1b0e-453d-a672-0b7c555df525".device = "/dev/disk/by-uuid/8f66deac-1b0e-453d-a672-0b7c555df525";

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/D3A0-8CE5";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

  swapDevices = [ ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}

