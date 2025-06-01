{
  pkgs,
  config,
  lib,
  ...
}:
let
  purp = config.module.purpose;
  include = config.module.include;
in
{
  boot.loader = {
    timeout = 3;
    grub = {
      default = "saved";
      device = "nodev";
      efiSupport = true;
      useOSProber = include.windowsDualboot;

      splashImage = null;
      backgroundColor = "#000000";
      theme = "${pkgs.n1x0s-grub}";
    };
  };

  boot = {
    kernelPackages = pkgs.linuxPackages_6_6;
    # Configuration for base root filesystem (ramdisk)
    # Kernel gets initial tools here that needed to mount system disk partitions
    initrd = {
      systemd.enable = true;
      verbose = false;
    };

    # Some hardening
    kernel.sysctl = {
      "fs.suid_dumpable" = 0;
      "fs.protected_fifos" = 2;
      "fs.protected_regular" = 2;
      "kernel.kptr_restrict" = 2;
      "kernel.kexec_load_disabled" = 1;
      "kernel.yama.ptrace_scope" = 2;
      "net.ipv4.tcp_syncookies" = false;
      "vm.swappiness" = 23;
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
    # Mounts /tmp in ram
    # Potentially can be a problem for huge nix config in future
    # Or when you have 5KiB of ram
    tmp.useTmpfs = lib.mkDefault (!purp.server);
  };
}
