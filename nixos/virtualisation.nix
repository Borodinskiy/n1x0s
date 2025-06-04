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
    virtualisation.virtualbox.host.enable = true;
    users.extraGroups.vboxusers.members = [
      "${sigmaUser}"
    ];

    virtualisation.docker.enable = true;

    environment.systemPackages = with pkgs; [
      docker-compose
      qemu
    ];
  };
}
