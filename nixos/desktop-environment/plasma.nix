{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.module.de.plasma;
in
{
  config = lib.mkIf cfg.enable {
    services.displayManager.defaultSession = "plasma";
    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      autoNumlock = true;
      theme = "sddm-custom-bg";
      settings.Theme = {
        CursorTheme = config.module.theme.cursor.name;
        CursorSize = config.module.theme.cursor.size;
      };
    };

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
      # Custom background package for display manager
      sddm-custom-bg
    ];
  };
}
