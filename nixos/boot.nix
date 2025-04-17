{
  config,
  lib,
  ...
}:
let
  purp = config.module.purpose;
in
{
  boot.loader = {
    timeout = 3;
    grub = {
      default = "saved";
      device = "nodev";
      efiSupport = true;
    };
  };

  boot = {
    # Configuration for base root filesystem (ramdisk)
    # Kernel gets initial tools here that needed to mount system disk partitions
    initrd = {
      systemd.enable = true;
      verbose = false;
    };

    # Disable on screen logging for cleaner boot
    # We can temporary enable it again in the bootloader menu
    consoleLogLevel = 0;
    kernelParams = [
      # For fixing things
      "boot.shell_on_fail"
      # Idk, maybe for plymouth
      "quiet"
      # Disable on screen log
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
    ];
    # Keeps /tmp content only in ram
    # Potentially can be a problem for huge nix config in future
    # Or when you have 5KiB of ram
    tmp.useTmpfs = lib.mkDefault (!purp.server);
  };
}
