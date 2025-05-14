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

      fsoptionsLin = [
        "rw"
        "discard"
      ];
      fsoptionsHDD = [
        "rw"
        "uid=${user_uid}"
      ];
      fsoptionsSSD = [
        "rw"
        "uid=${user_uid}"
        "discard"
      ];
    in
    {
      "/" = {
        device = "/dev/disk/by-uuid/ef56e1c4-16cd-4998-bf23-c53fe41412d1";
        fsType = "ext4";
        options = fsoptionsLin;
      };
      "/efi" = {
        device = "/dev/disk/by-uuid/7F38-D49E";
        fsType = "vfat";
        options = [
          "fmask=0022"
          "dmask=0022"
        ];
      };
      "/run/media/${sigmaUser}/drive_d" = {
        device = "/dev/disk/by-uuid/F092237692234108";
        fsType = "ntfs3";
        options = fsoptionsHDD;
      };
      "/run/media/${sigmaUser}/drive_p" = {
        device = "/dev/disk/by-uuid/0EAEE44AAEE42C41";
        fsType = "ntfs3";
        options = fsoptionsSSD;
      };
    };

  swapDevices = [ { device = "/dev/disk/by-uuid/6eea38ad-bfb2-4ae3-ba3c-12a6164217c5"; } ];

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # Read context from link before changing value
  # https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion
  system.stateVersion = "24.11"; # Did you read the comment?
}
