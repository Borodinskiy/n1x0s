{ outputs, ... }:
{
  nix = {
    channel.enable = false;

    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  nixpkgs.overlays = [
    outputs.overlays.custom
    outputs.overlays.unstable
  ];
}
