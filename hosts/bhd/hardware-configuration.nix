{
  config,
  lib,
  modulesPath,
  sigmaUser,
  sigmaUidStr,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];
  boot = {
    loader = {
      efi.efiSysMountPoint = "/efi";
      grub.useOSProber = true;
    };
    supportedFilesystems = [ "ntfs" ];
    initrd.availableKernelModules = [
      "xhci_pci"
      "ahci"
      "nvme"
      "usbhid"
      "usb_storage"
      "sd_mod"
    ];
    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];
    kernelParams = [ "nowatchdog" ];
    blacklistedKernelModules = [ "iTCO_wdt" ]; # intel watchdog
  };
  fileSystems =
    let
      user_uid = sigmaUidStr;
      #user_gid = "100";  # "users" group id

      fsoptions_lin = [
        "rw"
        "discard"
      ];
      fsoptions_hdd = [
        "rw"
        "uid=${user_uid}"
      ];
      fsoptions_ssd = [
        "rw"
        "uid=${user_uid}"
        "discard"
      ];
    in
    {
      "/" = {
        device = "/dev/disk/by-uuid/8b915372-6eb3-4b67-97ff-5e666d01434c";
        fsType = "ext4";
        options = fsoptions_lin;
      };
      "/efi" = {
        device = "/dev/disk/by-uuid/F2AE-D541";
        fsType = "vfat";
        options = [
          "fmask=0022"
          "dmask=0022"
        ];
      };
      "/run/media/${sigmaUser}/drive_d" = {
        device = "/dev/disk/by-uuid/F092237692234108";
        fsType = "ntfs3";
        options = fsoptions_hdd;
      };
      "/run/media/${sigmaUser}/drive_g" = {
        device = "/dev/disk/by-uuid/54E4EE59E4EE3D3C";
        fsType = "ntfs3";
        options = fsoptions_ssd;
      };
      "/run/media/${sigmaUser}/drive_p" = {
        device = "/dev/disk/by-uuid/262CBC932CBC600B";
        fsType = "ntfs3";
        options = fsoptions_ssd;
      };
    };

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 8 * 1024;
    }
  ];

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # Read context from link before changing value
  # https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion
  system.stateVersion = "24.05"; # Did you read the comment?
}
