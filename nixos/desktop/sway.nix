{
  config,
  lib,
  ...
}:
let
  cfg = config.module.de.sway;
  gpu = config.module.driver.gpu;
in
{
  config = lib.mkIf cfg.enable {
    programs.sway = {
      enable = true;
      extraOptions = lib.optionals gpu.nvidia.enable [ "--unsupported-gpu" ];
    };

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

    xdg.portal = {
      enable = true;
      wlr.enable = true;
    };
  };
}
