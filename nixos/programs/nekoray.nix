{
  config,
  lib,
  ...
}:
let
  cfg = config.module.include.surf;
in
{
  config = lib.mkIf cfg {
    programs.nekoray = {
      enable = true;
      tunMode.enable = true;
    };
  };
}
