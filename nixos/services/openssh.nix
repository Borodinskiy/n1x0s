{
  config,
  lib,
  sigmaUser,
  ...
}:
{
  services.openssh = {
    enable = true;

    openFirewall = config.module.purpose.server;
    ports = [ 40242 ];

    settings = {
      AllowUsers = [ "${sigmaUser}" ];
      PasswordAuthentication = true;
      PermitRootLogin = lib.mkDefault "no";
      UseDns = true;
      X11Forwarding = false;
    };
  };
}
