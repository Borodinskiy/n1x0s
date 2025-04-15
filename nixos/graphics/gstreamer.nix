{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.hardware.graphics;
  lp = "/lib/gstreamer-1.0";
in
{
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs.gst_all_1; [
      gst-libav
      gst-vaapi

      gst-plugins-bad
      gst-plugins-base
      gst-plugins-good
      gst-plugins-ugly

      gstreamer
    ];
    environment.sessionVariables = {
      # Source: https://wiki.nixos.org/wiki/GStreamer
      GST_PLUGIN_SYSTEM_PATH_1_0 =
        with pkgs.gst_all_1;
        builtins.replaceStrings [ "/lib" ] [ "/lib/gstreamer-1.0" ] (
          pkgs.lib.makeLibraryPath [
            gst-libav
            gst-vaapi
            gst-plugins-bad
            gst-plugins-base
            gst-plugins-good
            gst-plugins-ugly
            gstreamer.out
          ]
        );
    };
  };
}
