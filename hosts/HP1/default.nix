{ lsDir, ... }:
{
  networking.hostName = "HP1";

  imports = lsDir ./.;

  module = {
    purpose.home = true;

    driver.gpu.amd.enable = true;

    de.plasma.enable = true;
  };
}
