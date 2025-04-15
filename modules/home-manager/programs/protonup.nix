{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.module.include.gaming;
  cfgHome = config.home.homeDirectory;
in
{
  config = lib.mkIf cfg {
    home.packages = with pkgs; [
      protonup
    ];
    home.sessionVariables = {
      STEAM_EXTRA_COMPAT_TOOLS_PATHS = "${cfgHome}/.steam/root/compatibilitytools.d";
    };
  };
}
