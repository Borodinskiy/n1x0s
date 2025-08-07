{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.module.de.plasma;
  cfgDm = config.module.dm.sddm;
  theme = config.module.theme;
in
{
  config = lib.mkMerge [
    (lib.mkIf cfgDm.enable {
      services.displayManager.defaultSession = "plasma";
      services.displayManager.sddm = {
        enable = true;
        wayland.enable = true;
        autoNumlock = true;
        settings.Theme = {
          CursorTheme = theme.cursor.name;
          CursorSize = theme.cursor.size;
        };
      };
      environment.systemPackages = with pkgs; [
        # Custom cursor theme
        theme.cursor.package
        # Custom background by making a configuration file
        (writeTextDir "share/sddm/themes/breeze/theme.conf.user" ''
          [General]
          background = ${theme.wallpaper.displayManager}
        '')

      ];
    })

    (lib.mkIf cfg.enable {
      services.desktopManager.plasma6 = {
        enable = true;
        enableQt5Integration = true;
      };

      xdg.portal.enable = true;
      # Kde contacts, mail, etc. No need
      programs.kde-pim.enable = false;

      environment.plasma6.excludePackages = with pkgs.kdePackages; [
        konsole
        elisa
        ksystemstats
        khelpcenter
        plasma-browser-integration
        plasma-systemmonitor
        plasma-workspace-wallpapers
      ];

      environment.systemPackages = with pkgs // pkgs.kdePackages; [
        # Support of windows wallpaper animated program
        wallpaper-engine-plugin
        xdg-desktop-portal-gtk
      ];
    })
  ];
}
