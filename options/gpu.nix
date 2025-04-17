{ lib, ... }:
{
  options.module.driver.gpu = {
    amd = lib.mkEnableOption "amd things";
    nvidia = lib.mkEnableOption "nvidia things";
    intel = lib.mkEnableOption "intel things";
  };
}
