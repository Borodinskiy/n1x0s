{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.module.include.redactor;
in
{
  config = lib.mkIf cfg {
    environment.systemPackages = with pkgs; [
      obs-studio
    ];
    boot = {
      extraModulePackages = with config.boot.kernelPackages; [
        v4l2loopback
      ];
      kernelModules = [ "v4l2loopback" ];
      # Support for virtual camera and gphoto2 protocol
      extraModprobeConfig = ''
        options v4l2loopback devices=2 video_nr=1,2 card_label="OBS Cam, Virt Cam" exclusive_caps=1
      '';
    };

    security.polkit.enable = true;
  };
}
