{ pkgs, config, ... }:
{
  hardware.graphics = {
    enable32Bit = config.hardware.graphics.enable;
    package = pkgs.mesa.drivers;
    package32 = pkgs.pkgsi686Linux.mesa.drivers;
  };
}
