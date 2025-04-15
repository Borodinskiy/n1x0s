{ config, lib, ... }:
let
  cfg = with config.module.include; surf || redactor;
in
{
  config = lib.mkIf cfg {
    programs.noisetorch.enable = true;
  };
}
