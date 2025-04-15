{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.module.driver.gpu.amd;
in
{

  config = lib.mkIf cfg {
    services.xserver.videoDrivers = [ "amdgpu" ];

    hardware.graphics = {
      enable = true;
      extraPackages = with pkgs; [
        amdvlk
        rocmPackages.clr.icd
      ];
      extraPackages32 = with pkgs; [
        driversi686Linux.amdvlk
      ];
    };

    environment.systemPackages = with pkgs; [
      nvtopPackages.amd
    ];

    systemd.tmpfiles.rules = [
      "L+ /opt/rocm/hip - - - - ${pkgs.rocmPackages.clr}"
    ];
  };
}
