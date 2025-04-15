{ config, lib, ... }:
let
  cfg = config.module.purpose.home;
in
{
  config = lib.mkIf cfg {
    services.libinput = {
      mouse.accelProfile = "flat";
      touchpad.tappingDragLock = false;
    };
  };
}
