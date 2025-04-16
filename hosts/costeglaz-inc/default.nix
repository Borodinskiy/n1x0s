{
  modulesPath,
  lib,
  pkgs,
  sigmaUser,
  lsDir,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
  ] ++ lsDir ./.;
  boot.loader.grub = {
    # no need to set devices, disko will add all devices that have a EF02 partition to the list already
    # devices = [ ];
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 4 * 1024;
    }
  ];

  networking.hostName = "costeglaz-inc";
  services.qemuGuest.enable = true;

  virtualisation.docker.enable = true;
  environment.systemPackages = with pkgs; [
    curlWithGnuTls
    docker-compose
    nixd
  ];

  system.stateVersion = "24.05";
}
