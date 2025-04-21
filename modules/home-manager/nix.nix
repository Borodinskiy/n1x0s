{ outputs, ... }:
{
  nixpkgs.overlays = [
    outputs.overlays.additions
    outputs.overlays.unstable
  ];
}
