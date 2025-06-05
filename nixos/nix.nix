{ config, outputs, ... }:
{
  nix = {
    channel.enable = false;

    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  nixpkgs = {
    overlays = [
      outputs.overlays.custom
      outputs.overlays.unstable
      (outputs.overlays.overrides {
        cudaSupport = config.module.driver.gpu.nvidia.cuda.enable;
        hipSupport = config.module.driver.gpu.amd.rocm.enable;
      })
    ];
  };
}
