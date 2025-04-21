{ lsDir, ... }:
{
  networking.hostName = "bhd";

  imports = lsDir ./.;

  module = {
    purpose.home = true;

    driver.gpu.nvidia = {
      enable = true;
      cuda = true;
    };

    include.windowsDualboot = true;

    de.plasma.enable = true;
  };
}
