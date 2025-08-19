{
  lsDir,
  ...
}:
{
  imports = lsDir ./vfio-hooks;
  include.virtualisation.libvirt = true;

  boot = {
    initrd.availableKernelModules = [
      "vfio"
      "vfio_iommu_type1"
      "vfio_pci"
    ];

    kernelParams = [
      "intel_iommu=on"
      "iommu=pt"
    ];
  };
}
