{ config, sigmaUser, ... }:
{
  services.gitolite = {
    enable = true;
    adminPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL9y+zENBzr85QhVWboMCki1X1/ja2d2yz423gRmjK2j ${sigmaUser}@${config.networking.hostName}";
  };

  module.openssh.autostart = true;
  services.openssh.settings = {
    AllowUsers = [ config.services.gitolite.user ];
  };
}
