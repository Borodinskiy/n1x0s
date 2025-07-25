{
  config,
  lib,
  sigmaUser,
  ...
}:
let
  cfg = config.module.purpose.home;
in
{
  config = lib.mkIf cfg {
    services.syncthing = {
      enable = lib.mkDefault true;

      user = sigmaUser;
      group = "users";
      dataDir = "/home/${sigmaUser}";
    };
  };
}
