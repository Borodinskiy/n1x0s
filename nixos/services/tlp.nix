{ config, lib, ... }:
let
  cfg = config.module.purpose.laptop;
in
{
  options = {
    module.tlp = {
      maxPerformance = lib.mkOption {
        description = "max % of cpu frequency on AC power";
        default = 100;
      };
      maxBatPerformance = lib.mkOption {
        description = "max % of cpu frequency on BAT power";
        default = config.module.tlp.maxPerformance * 0.75;
      };
    };
  };
  config = lib.mkIf cfg {
    services.power-profiles-daemon.enable = false;
    services.tlp = {
      enable = true;
      settings = {
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
        CPU_SCALING_GOVERNOR_ON_AC = "performance";

        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

        CPU_MIN_PERF_ON_BAT = 0;
        CPU_MIN_PERF_ON_AC = 0;

        CPU_MAX_PERF_ON_BAT = config.module.tlp.maxBatPerformance;
        CPU_MAX_PERF_ON_AC = config.module.tlp.maxPerformance;
      };
    };
  };
}
