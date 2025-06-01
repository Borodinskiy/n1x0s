{ lib, ... }:
{
  options.module.driver.gpu = {
    amd = {
      enable = lib.mkEnableOption "amd things";
      rocm.enable = lib.mkEnableOption "amd ROCm toolkit and libraries";
    };

    nvidia = {
      enable = lib.mkEnableOption "nvidia things";
      cuda.enable = lib.mkEnableOption "nvidia CUDA toolkit and libraries";
    };

    intel.enable = lib.mkEnableOption "intel things";
  };
}
