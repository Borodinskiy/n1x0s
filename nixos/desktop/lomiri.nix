{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.module.de.lomiri;
in
{
  config = lib.mkIf cfg.enable {
    services.desktopManager.lomiri.enable = true;
  };
}
