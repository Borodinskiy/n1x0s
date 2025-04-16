{
  pkgs,
  config,
  lib,
  sigmaUser,
  resourcePath,
  ...
}:
let
  cfg = config.module.include.printscan;
in
{
  config = lib.mkIf cfg {
    services.printing.enable = true;
    users.groups.lp.members = [ "${sigmaUser}" ];

    # Utilities for printer
    environment.systemPackages = with pkgs; [
      system-config-printer
    ];

    services.printing.drivers = with pkgs; [
      # Many drivers for printers
      gutenprint
      gutenprintBin
      # HP
      hplip
      # Samsung
      samsung-unified-linux-driver
      # Samsung Printer Language
      splix
      # Some brother printers
      brlaser
      # Canon
      canon-cups-ufr2

      # Custom

      (writeTextDir "share/cups/model/i-sensys-MF4410.ppd" (
        builtins.readFile (resourcePath + "/ppd/canon/i-sensys-MF4410.ppd")
      ))
      (writeTextDir "share/cups/model/xerox-phaser-3020.ppd" (
        builtins.readFile (resourcePath + "/ppd/phaser3020/Samsung_M2020_Series.ppd")
      ))
    ];
  };
}
