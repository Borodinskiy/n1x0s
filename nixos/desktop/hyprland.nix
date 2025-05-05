{
  config,
  lib,
  sigmaUser,
  ...
}:
let
  cfg = config.module.de.hyprland;
in
{
  config = lib.mkIf cfg.enable {
    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
      withUWSM = true;
    };

    module.include.wmTools.enable = true;

    # Idle daemon for actions like lockscreen
    services.hypridle.enable = true;
    # Lockscreen
    programs.hyprlock.enable = true;

    services.gnome.gnome-keyring.enable = true;
  };
}
