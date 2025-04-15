{
  pkgs,
  config,
  lib,
  sigmaUser,
  ...
}:
let
  cfg = config.module.include.printscan;
in
{
  config = lib.mkIf cfg {
    hardware.sane.enable = true;
    users.groups.scanner.members = [ "${sigmaUser}" ];

    # Utilities for scanner
    environment.systemPackages = with pkgs; [
      simple-scan
    ];
  };
}
