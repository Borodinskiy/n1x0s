{ config, lib, ... }:
let
  cfg = config.module.purpose.home;
in
{
  config = lib.mkIf cfg {
    services = {
      # GVfs, userspace virtual filesystem (for mtp)
      gvfs.enable = true;
      # Mount usb
      udisks2.enable = true;
    };
  };
}
