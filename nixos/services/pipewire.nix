{ config, lib, ... }:
let
  cfg = config.module.purpose.home;
in
{
  config = lib.mkIf cfg {
    # RealtimeKit system service which hands realtime scheduling priority.
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
      extraConfig.pipewire."92-low-latency" = {
        "context.properties" = {
          "default.clock.rate" = 48000;
          "default.clock.quantum" = 2048;
          "default.clock.min-quantum" = 2048;
          "default.clock.max-quantum" = 4096;
        };
      };
      extraConfig.pipewire-pulse."92-low-latency" = {
        "context.properties" = [
          {
            name = "libpipewire-module-protocol-pulse";
            args = { };
          }
        ];
        "pulse.properties" = {
          "pulse.default.req" = "2048/48000";
          "pulse.min.req" = "2048/48000";
          "pulse.max.req" = "4096/48000";
          "pulse.min.quantum" = "2048/48000";
          "pulse.max.quantum" = "4096/48000";
        };
        "stream.properties" = {
          "node.latency" = "2048/48000";
          "resample.quality" = 1;
        };
      };
    };
  };
}
