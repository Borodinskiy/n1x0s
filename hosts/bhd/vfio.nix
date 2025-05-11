{
  pkgs,
  sigmaUser,
  lsDir,
  ...
}:
{
  imports = lsDir ./vfio-hooks;

  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;
  programs.virt-manager.enable = true;

  services.displayManager.sessionPackages = with pkgs; [
    (n1x0s-session.override {
      name = "Windows";
      command = "${systemd}/bin/systemctl start win10-vfio";
    })
  ];

  systemd.services.win10-vfio = with pkgs; {
    enable = true;
    path = [ libvirt ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${libvirt}/bin/virsh start win10-with-vfio";
    };
  };

  # No auth when launching program
  users.groups.libvirtd.members = [ "${sigmaUser}" ];

  boot = {
    initrd.availableKernelModules = [
      "vfio"
      "vfio_iommu_type1"
      "vfio_pci"
      #"vfio_virqfd"
    ];

    kernelParams = [
      "intel_iommu=on"
      "iommu=pt"
    ];
  };
}
