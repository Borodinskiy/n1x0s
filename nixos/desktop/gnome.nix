{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.module.de.gnome;
in
{
  config = lib.mkIf cfg.enable {
    services.xserver = {
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
    };

    services.gnome = {
      evolution-data-server.enable = lib.mkForce false;
      gnome-browser-connector.enable = false;
      gnome-online-accounts.enable = false;
      gnome-remote-desktop.enable = false;
      gnome-user-share.enable = false;
      gnome-initial-setup.enable = false;
    };

    xdg.portal.enable = true;

    environment.gnome.excludePackages = with pkgs; [
      geary
      gnome-maps
      gnome-clocks
      gnome-contacts
      gnome-disk-utility
      gnome-logs
      gnome-music
      gnome-system-monitor
      gnome-tour
      gnome-weather
    ];
  };
}
