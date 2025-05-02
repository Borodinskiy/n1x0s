{ outputs, ... }:
{
  nixpkgs.overlays = [
    outputs.overlays.custom
    outputs.overlays.unstable
  ];
}
