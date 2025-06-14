{ lib, ... }:
{
  options.module.purpose = {
    server = lib.mkEnableOption "setup for server devices";
    home = lib.mkEnableOption "setup for home devices";
  };
}
