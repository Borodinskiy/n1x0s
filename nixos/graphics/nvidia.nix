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

  config = lib.mkIf cfg {
    services.xserver.videoDrivers = [ "nvidia" ];

    hardware.graphics.enable = true;

    # Ensure that after enabling this EVERY shit that need gpu will W-O-R-K?!!?!?!?
    # + kde lags ☺️ ☺️ ☺️ ☺️ ☺️ ☺️ ☺️ ☺️ ☺️ ☺️ ☺️ ☺️ ☺️ ☺️ ☺️ ☺️ ☺️ ☺️ ☺️ ☺️ ☺️ ☺️ ☺️ ☺️ ☺️ ☺️ ☺️ ☺️ ☺️ ☺️ ☺️
    hardware.nvidia = {
      open = false; # Eeeeeei opin souce
      nvidiaSettings = false;
    };

    environment.systemPackages = with pkgs; [
      nvtopPackages.nvidia
    ];
  };
}
