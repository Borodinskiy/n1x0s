{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.module.driver.gpu.nvidia;
in
{
  config = lib.mkIf cfg.enable {
    services.xserver.videoDrivers = [ "nvidia" ];

    hardware.graphics.enable = true;

    hardware.nvidia.open = false;

    environment.systemPackages = with pkgs; [
      nvtopPackages.nvidia
    ];
  };
}
