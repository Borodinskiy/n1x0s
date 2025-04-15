{ config, lib, ... }:
let
  cfg = config.home.sessionVariables;
  cfgHome = config.home.homeDirectory;
  cfgDataHome = config.xdg.dataHome;
in
{
  home.sessionVariables = {
    # Use vim alias-like thing as editor
    EDITOR = "vim";
    VISUAL = "vim";

    # Uniform open/save dialog for gtk apps if they have xdg desktop portal support
    GTK_USE_PORTAL = "1";
    # Fix for qt 😊. Now you should set it's theme via kde plasma's systemsettings
    # Or... declaratively, using nix
    QT_QPA_PLATFORMTHEME = "kde";

    # Where user store its documents, saves, etc.
    # By default its user's $HOME directory
    # So if main data located on other drive, change this variable in host's module
    # Used for bookmarks and scripts
    HOME_MYFILES = lib.mkDefault "${cfgHome}";
    # Home of workspace directory. It store configuration, include nix's itself
    HOME_WORKSPACE = lib.mkDefault "${cfg.HOME_MYFILES}/sync/workspace";
    # Extra binaries locations
    PATH = "$HOME/.local/bin:${cfg.HOME_WORKSPACE}/bin:$PATH";

    # Prioritize wayland for graphical toolkits
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
    CLUTTER_BACKEND = "wayland";
    GDK_BAKEND = "wayland,x11";
    QT_QPA_PLATFORM = "wayland;xcb";
    _JAVA_AWT_WM_NONREPARENTING = "1";
  };
}
