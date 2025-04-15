{
  sigmaUser,
  config,
  lib,
  modulesPath,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];
  boot = {
    loader = {
      efi.efiSysMountPoint = "/boot";
      grub.efiInstallAsRemovable = true;
    };
    initrd = {
      availableKernelModules = [
        "nvme"
        "xhci_pci"
        "usb_storage"
        "usbhid"
        "sd_mod"
      ];
      kernelModules = [ "amdgpu" ];
    };
    kernelModules = [ "kvm-amd" ];
    extraModulePackages = [ ];
    kernelParams = [ "nowatchdog" ];
    blacklistedKernelModules = [
      "sp5100_tco" # amd watchdog
    ];
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/d7a14218-72c4-44eb-a116-762def76e0c5";
    fsType = "ext4";
    options = [ "discard" ];
  };
  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/701A-5281";
    fsType = "vfat";
    options = [
      "fmask=0022"
      "dmask=0022"
    ];
  };

  swapDevices = [
    {
      device = "/dev/disk/by-uuid/e0ac061c-99d3-4f16-99f3-e0451f4609ba";
    }
  ];

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # Read context from link before changing value
  # https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion
  system.stateVersion = "24.11"; # Did you read the comment?
}
