{ pkgs, ... }:
{
  programs.nix-ld = {
    enable = false;
    libraries = with pkgs; [
      stdenv.cc.cc.lib
      libz
      gnutls
      curlWithGnuTls
    ];
  };
}
