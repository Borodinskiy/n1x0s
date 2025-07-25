{ config, lib, ... }:
{
  services.flatpak.enable = lib.mkDefault config.module.purpose.home;
}