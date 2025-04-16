{ lsDir, ... }:
{
  networking.hostName = "bhd";

  imports = lsDir ./.;

  module = {
    purpose.home = true;

    driver.gpu.nvidia = true;

    include.windowsDualboot = true;

    de.plasma.enable = true;
  };
}
