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
    config.cudaSupport = config.module.driver.gpu.nvidia.cuda.enable;
    config.hipSupport = config.module.driver.amd.rocm.enable;
    overlays = [
      outputs.overlays.custom
      outputs.overlays.unstable
      outputs.overlays.fixmes
    ];
  };
}
