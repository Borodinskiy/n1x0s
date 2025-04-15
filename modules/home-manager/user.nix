{ sigmaUser, ... }:
{
  programs.home-manager.enable = true;
  home = {
    username = sigmaUser;
    homeDirectory = "/home/${sigmaUser}";
  };
}
