{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.module.dm.greetd;
in
{
  config = lib.mkIf cfg.enable {
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd sway";
          user = "greeter";
        };
      };
    };
  };
}
