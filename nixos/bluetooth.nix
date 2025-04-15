{ config, lib, ... }:
let
  cfg = config.module.purpose.home;
in
{
  config = lib.mkIf cfg {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = false;
    };
  };
}
