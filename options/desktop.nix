{ config, lib, ... }:
let
  cfg = config.module;
in
{
  options.module.de = {
    plasma = {
      enable = lib.mkEnableOption "kde plasma";
    };

    sway.enable = lib.mkEnableOption "sway";

    hyprland.enable = lib.mkEnableOption "hyprland";
  };

  options.module.dm = {
    greetd.enable = lib.mkEnableOption "greetd display manager";
    sddm.enable = lib.mkEnableOption "sddm" // {
      default = cfg.de.plasma.enable;
    };
  };
}
