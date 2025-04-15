{ sigmaUser, sigmaUid, ... }:
{
  users = {
    users."${sigmaUser}" = {
      extraGroups = [ "wheel" ]; # Admin
      isNormalUser = true;
      uid = sigmaUid;
    };
  };
}
