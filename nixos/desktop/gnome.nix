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
  config = lib.mkMerge [
    (lib.mkIf cfg.displayManager.enable {
      services.displayManager.gdm.enable = true;
    })

    (lib.mkIf cfg.enable {
      services.desktopManager.gnome.enable = true;

      services.gnome = {
        evolution-data-server.enable = lib.mkForce false;
        gnome-online-accounts.enable = false;
        gnome-browser-connector.enable = false;
        gnome-initial-setup.enable = false;
        gnome-remote-desktop.enable = false;
        gnome-user-share.enable = false;
        rygel.enable = false;
      };
      services.geoclue2.enable = false;
      services.hardware.bolt.enable = false;

      environment.gnome.excludePackages = with pkgs; [
        geary
        seahorse
        baobab
        decibels
        epiphany
        gnome-text-editor
        gnome-tour
        gnome-calculator
        gnome-calendar
        gnome-clocks
        gnome-console
        gnome-contacts
        gnome-disk-utility
        gnome-maps
        gnome-music
        gnome-system-monitor
        gnome-weather
        loupe
        gnome-connections
        snapshot
        totem
        yelp
      ];

      environment.systemPackages = with pkgs.gnomeExtensions; [
        dock-from-dash
      ];
    })
  ];
}
