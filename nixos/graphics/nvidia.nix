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

    # Ensure that after enabling this EVERY shit that need gpu will W-O-R-K?!!?!?!?
    # + kde lags ☺️ ☺️ ☺️ ☺️ ☺️ ☺️ ☺️ ☺️ ☺️ ☺️ ☺️ ☺️ ☺️ ☺️ ☺️ ☺️ ☺️ ☺️ ☺️ ☺️ ☺️ ☺️ ☺️ ☺️ ☺️ ☺️ ☺️ ☺️ ☺️ ☺️ ☺️
    hardware.nvidia = {
      modesetting.enable = true;
      powerManagement.enable = false;
      powerManagement.finegrained = false;
      open = false; # Eeeeeei opin souce
      nvidiaSettings = false;
      package = config.boot.kernelPackages.nvidiaPackages.latest;
    };

    environment.systemPackages = with pkgs; [
      nvtopPackages.nvidia
    ];
  };
}
