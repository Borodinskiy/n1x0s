{
  sigmaUser,
  lsDir,
  ...
}:
{
  imports = lsDir ./vfio-hooks;

  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;
  programs.virt-manager.enable = true;

  # No auth when launching program
  users.groups.libvirtd.members = [ sigmaUser ];

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
