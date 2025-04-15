{ config, lib, ... }:
let
  cfg = config.module.purpose.home;
in
{
  config = lib.mkIf cfg {
    # Keyring daemon in user sessions
    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };
}
