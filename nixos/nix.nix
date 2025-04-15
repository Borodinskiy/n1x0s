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
    outputs.overlays.additions
    outputs.overlays.unstable
  ];
}
