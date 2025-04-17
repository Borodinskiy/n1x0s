{
  config,
  lib,
  ...
}:
let
  cfg = config.module.include.gaming;
in
{
  config = lib.mkIf cfg {
    programs.steam.enable = true;
  };
}
