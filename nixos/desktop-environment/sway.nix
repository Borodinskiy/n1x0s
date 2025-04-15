{
  pkgs,
  config,
  lib,
  sigmaUser,
  ...
}:
let
  cfg = config.module.de.sway;
in
{
  config = lib.mkIf cfg.enable {
    programs.sway.enable = true;

    module.include.wmTools = true;

    services.gnome.gnome-keyring.enable = true;

    security = {
      polkit.enable = true;
      pam.loginLimits = [
        {
          domain = "@users";
          item = "rtprio";
          type = "-";
          value = 1;
        }
      ];
    };

    systemd.user.services.polkit-kde-authentication-agent-1 = {
      description = "polkit-kde-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit-kde-agent}/libexec/polkit-kde-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };

    xdg.portal = {
      enable = true;
      wlr.enable = true;
    };

    programs.light.enable = true;
    users.extraGroups.video.members = [ "${sigmaUser}" ];
  };
}
