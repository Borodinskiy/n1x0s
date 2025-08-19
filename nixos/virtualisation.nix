{
  pkgs,
  config,
  lib,
  sigmaUser,
  ...
}:
let
  cfg = config.module.include.virtualisation;
in
{
  config = lib.mkMerge [
    (lib.mkIf cfg.libvirt {
      virtualisation.libvirtd.enable = true;
      virtualisation.spiceUSBRedirection.enable = true;

      programs.virt-manager.enable = true;
      # No auth when using virt-manager
      users.groups.libvirtd.members = [ sigmaUser ];
    })

    (lib.mkIf cfg.virtualbox {
      virtualisation.virtualbox.host.enable = true;
      users.extraGroups.vboxusers.members = [
        sigmaUser
      ];
    })

    (lib.mkIf cfg.docker {
      virtualisation.docker.enable = true;
      environment.systemPackages = with pkgs; [ docker-compose ];
    })

    (lib.mkIf cfg.qemu {
      environment.systemPackages = with pkgs; [ qemu ];
    })
  ];
}
