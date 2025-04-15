{ pkgs, lib, ... }:
{
  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "steamcmd"
      "steam-unwrapped"
    ];

  environment.systemPackages = with pkgs; [
    steamcmd
    steam-run
  ];
}
