{ config, lib, ... }:
let
  cfg = config.module.purpose.home;
in
{
  config = lib.mkIf cfg {
    services.xserver.desktopManager.xterm.enable = false;
  };
}
