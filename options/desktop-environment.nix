{ lib, ... }:
{
  options.module.de = {
    plasma.enable = lib.mkEnableOption "kde plasma";
    gnome.enable = lib.mkEnableOption "gnome destop environmente";
    lomiri.enable = lib.mkEnableOption "Lomiri desktop environment";

    sway.enable = lib.mkEnableOption "sway";
    hyprland.enable = lib.mkEnableOption "hyprland";
  };
}
