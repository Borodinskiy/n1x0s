{
  config,
  lib,
  sigmaUser,
  ...
}:
let
  cfg = config.module.include.gaming;
in
{
  config = lib.mkIf cfg {
    # Daemon that optimize hardware performance when playing games
    # Works automatically or by gamemoderun /path/to/bin
    programs.gamemode = {
      enable = true;
      settings.general = {
        reaper_freq = 15;
        desiredgov = "performance";
        defaultgov = "powersave";
        igpu_desiredgov = "performance";
        igpu_power_threshold = -1;
        softrealtime = "off";
        renice = 7;
        ioprio = 0;
        inhibit_screensaver = 1;
        disable_splitlock = 1;
      };
    };
    # Without it gamemode daemon can't apply it's settings on hardware
    users.extraGroups.gamemode.members = [ sigmaUser ];
  };
}
