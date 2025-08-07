{ pkgs, lsDir, ... }:
{
  networking.hostName = "bhd";

  imports = lsDir ./.;

  module = {
    purpose.home = true;

    driver.gpu.nvidia = {
      enable = true;
      cuda.enable = true;
    };

    include.windowsDualboot = true;

    de.plasma.enable = true;
  };

  environment.systemPackages = with pkgs; [
    rpcs3
    pcsx2
    ryujinx
    cemu
  ];
}
