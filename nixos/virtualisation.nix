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
  config = lib.mkIf cfg {
    # FIXME: virtualbox-modules are broken on the newest kernel
    #virtualisation.virtualbox.host.enable = true;
    #users.extraGroups.vboxusers.members = [
    #  "${sigmaUser}"
    #];

    virtualisation.docker.enable = true;

    environment.systemPackages = with pkgs; [
      docker-compose
      qemu
    ];
  };
}
