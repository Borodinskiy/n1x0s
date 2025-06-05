{
  lib,
  sigmaUser,
  ...
}:
{
  services.syncthing = {
    enable = lib.mkDefault true;

    user = sigmaUser;
    group = "users";
    dataDir = "/home/${sigmaUser}";
  };
}
