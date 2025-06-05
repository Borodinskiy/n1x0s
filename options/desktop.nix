{ config, lib, ... }:
let
  cfg = config.module;
in
{
  options.module.de = {
    plasma = {
      enable = lib.mkEnableOption "kde plasma";
      displayManager.enable = lib.mkEnableOption "sddm" // {
        default = cfg.de.plasma.enable;
      };
    };

    lomiri.enable = lib.mkEnableOption "lomiri desktop environment";

    sway.enable = lib.mkEnableOption "sway";

    hyprland.enable = lib.mkEnableOption "hyprland";
  };

  options.module.dm = {
    greetd.enable = lib.mkEnableOption "greetd display manager";
  };
}
