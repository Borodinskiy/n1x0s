{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.module.include.surf;
in
{
  config = lib.mkIf cfg {
    programs.mpv = {
      enable = true;
      package = (
        pkgs.mpv-unwrapped.wrapper {
          scripts = with pkgs.mpvScripts; [
            # Media player support in desktop environments
            mpris
          ];
          mpv = pkgs.mpv-unwrapped.override {
            waylandSupport = true;
          };
        }
      );
    };
  };
}
