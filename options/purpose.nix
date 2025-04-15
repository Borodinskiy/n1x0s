{ lib, ... }:
{
  options.module.purpose = {
    server = lib.mkEnableOption "setup for server device";
    home = lib.mkEnableOption "setup for home devices";
  };
}
