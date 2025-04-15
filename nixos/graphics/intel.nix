{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.module.driver.gpu.intel;
in
{

  config = lib.mkIf cfg {
    services.xserver.videoDrivers = [ "intel" ];

    hardware.graphics = {
      enable = true;
      extraPackages = with pkgs; [
        intel-vaapi-driver
      ];
      extraPackages32 = with pkgs; [
        driversi686Linux.intel-vaapi-driver
      ];
    };

    environment.systemPackages = with pkgs; [
      nvtopPackages.intel
    ];
  };
}
