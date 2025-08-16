{
pkgs,
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
    # FIXME: this not shows in lanzaboote systemd-boot version
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot = {
        windows = {
          "windows" = {
            title = "Windows";
            efiDeviceHandle = "HD1b3";
            sortKey = "y_windows";
          };
        };
        edk2-uefi-shell = {
          enable = true;
          sortKey = "z_edk2";
        };
      };
    };

    # secureboot
    loader.systemd-boot.enable = lib.mkForce false;
    loader.grub.enable = false;
    lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
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
  environment.systemPackages = with pkgs; [
    sbctl
  ];
  fileSystems =
    let
      user_uid = sigmaUidStr;
      user_gid = "100"; # "users" group id

      fsoptionsLin = [
        "rw"
        "discard"
      ];
      fsoptionsHDD = [
        "rw"
        "uid=${user_uid}"
        "gid=${user_gid}"
      ];
      fsoptionsSSD = fsoptionsHDD ++ [ "discard" ];
    in
    {
      "/" = {
        device = "/dev/disk/by-uuid/ef56e1c4-16cd-4998-bf23-c53fe41412d1";
        fsType = "ext4";
        options = fsoptionsLin;
      };
      "/boot" = {
        device = "/dev/disk/by-uuid/1092-7F10";
        fsType = "vfat";
        options = [
          "fmask=0137"
          "dmask=0027"
          "errors=remount-ro"
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
