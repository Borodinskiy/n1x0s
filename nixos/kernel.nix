{
  pkgs,
  ...
}:
{
  boot = {
    kernelPackages = pkgs.linuxPackages_cachyos;
    kernelModules = [ "ntsync" ];
  };

  # Sched-ext
  services.scx.enable = true;

  # Some hardening
  boot.kernel.sysctl = {
    "fs.suid_dumpable" = 0;
    "fs.protected_fifos" = 2;
    "fs.protected_regular" = 2;
    "kernel.kptr_restrict" = 2;
    "kernel.kexec_load_disabled" = 1;
    "kernel.yama.ptrace_scope" = 2;
    "net.ipv4.tcp_syncookies" = false;
    "vm.swappiness" = 23;
  };
}
