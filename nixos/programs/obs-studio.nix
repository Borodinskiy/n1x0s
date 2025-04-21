{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.module.include.redactor;
in
{
  config = lib.mkIf cfg {
    programs.obs-studio = {
      enable = true;
      enableVirtualCamera = true;
      plugins = with pkgs.obs-studio-plugins; [
        wlrobs
        obs-backgroundremoval
        obs-pipewire-audio-capture
        waveform
        obs-vkcapture
        obs-vintage-filter
        obs-vaapi
        obs-transition-table
        obs-source-switcher
        obs-source-clone
        obs-shaderfilter
        obs-rgb-levels-filter
        obs-replay-source
        obs-pipewire-audio-capture
        obs-move-transition
        obs-gstreamer
        obs-composite-blur
        obs-backgroundremoval
        obs-3d-effect
        advanced-scene-switcher
      ];
    };
  };
}
