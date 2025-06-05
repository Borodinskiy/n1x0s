{ sigmaUser, ... }:
{
  networking.networkmanager.enable = true;

  users.extraGroups.networkmanager.members = [ sigmaUser ];
}
