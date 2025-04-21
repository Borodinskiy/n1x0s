{ lib, ... }:
{
  options.module.driver.gpu = {
    amd = {
      enable = lib.mkEnableOption "amd things";
      rocm = lib.mkEnableOption "amd ROCm toolkit and libraries";
    };

    nvidia = {
      enable = lib.mkEnableOption "nvidia things";
      cuda = lib.mkEnableOption "nvidia CUDA toolkit and libraries";
    };

    intel.enable = lib.mkEnableOption "intel things";
  };
}
