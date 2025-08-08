{ lsDir, ... }:
{
  networking.hostName = "HP1";

  imports = lsDir ./.;

  module = {
    purpose.home = true;
    purpose.laptop = true;

    driver.gpu.amd.enable = true;

    include.windowsDualboot = true;

    de.plasma.enable = true;
  };
}
