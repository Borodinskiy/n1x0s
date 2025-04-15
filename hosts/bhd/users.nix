let
  user1 = "ponto";
in
{
  users.users."${user1}" = {
    isNormalUser = true;
    extraGroups = [ ];
  };

  services.displayManager.sddm.settings = {
    Users = {
      HideUsers = user1;
    };
  };
}
