{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.module.de.plasma;
  theme = config.module.theme;
in
{
  config = lib.mkMerge [
    (lib.mkIf cfg.displayManager.enable {
      services.displayManager.defaultSession = "plasma";
      services.displayManager.sddm = {
        enable = true;
        wayland.enable = true;
        autoNumlock = true;
        theme = "n1x0s-sddm";
        settings.Theme = {
          CursorTheme = theme.cursor.name;
          CursorSize = theme.cursor.size;
        };
      };
      environment.systemPackages = with pkgs; [
        # Custom background package for display manager
        n1x0s-sddm
        # Custom cursor theme
        theme.cursor.package
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
        elisa
        ksystemstats
        khelpcenter
        plasma-browser-integration
        plasma-systemmonitor
        plasma-workspace-wallpapers
      ];

      environment.systemPackages = with pkgs // pkgs.kdePackages; [
        xdg-desktop-portal-gtk
        # QT additional libraries
        qtdeclarative
        qtimageformats
        qtmultimedia
      ];
    })
  ];
}
