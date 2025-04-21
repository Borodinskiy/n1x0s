{
  config,
  lib,
  sigmaUser,
  ...
}:
let
  cfg = config.module.purpose;
in
{
  config = lib.mkMerge [
    # Disable service autostart on home machines
    (lib.mkIf cfg.home {
      systemd.services.sshd.wantedBy = lib.mkForce [ ];
    })

    {
      services.openssh = {
        enable = true;

        openFirewall = cfg.server;
        ports = [ 40242 ];

        settings = {
          AllowUsers = [ "${sigmaUser}" ];
          PasswordAuthentication = cfg.home;
          PermitRootLogin = lib.mkDefault "no";
          UseDns = true;
          X11Forwarding = false;
        };
      };
    }
  ];
}
