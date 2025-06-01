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
    gnome.enable = lib.mkEnableOption "gnome desktop environmente";
    lomiri.enable = lib.mkEnableOption "Lomiri desktop environment";

    sway.enable = lib.mkEnableOption "sway";
    hyprland.enable = lib.mkEnableOption "hyprland";
  };

  options.module.dp = {
    greetd.enable = lib.mkEnableOption "greetd display manager";
  };
}
