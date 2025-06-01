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

  config = lib.mkIf cfg.enable {
    services.xserver.videoDrivers = [ "amdgpu" ];

    hardware.graphics = {
      enable = true;
      extraPackages =
        with pkgs;
        [
          amdvlk
        ]
        ++ lib.optionals cfg.rocm.enable [ rocmPackages.clr.icd ];

      extraPackages32 = with pkgs; [
        driversi686Linux.amdvlk
      ];
    };

    environment.systemPackages = with pkgs; [
      nvtopPackages.amd
    ];

    # Fix for software that uses hadr-coded HIP libraries
    systemd.tmpfiles.rules =
      let
        rocmEnv = pkgs.symlinkJoin {
          name = "rocm-combined";
          paths = with pkgs.rocmPackages; [
            rocblas
            hipblas
            clr
          ];
        };
      in
      lib.mkIf cfg.rocm.enable [
        "L+ /opt/rocm - - - - ${rocmEnv}"
      ];
  };
}
