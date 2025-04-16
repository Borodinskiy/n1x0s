{ pkgs, lib, ... }:
let
  cfg = config.module.include.gaming;
in
{
  config = lib.mkIf cfg {
    programs.nix-ld = {
      enable = false;
      libraries = with pkgs; [
        stdenv.cc.cc.lib
        libz
        gnutls
        curlWithGnuTls
      ];
    };
  };
}
