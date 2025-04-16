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
    (lib.mkIf cfg.home {
      systemd.units.sshd.wantedBy = lib.mkForce [ ];
    })

    ({
      services.openssh = {
        enable = true;

        openFirewall = cfg.server;
        ports = [ 40242 ];

        settings = {
          AllowUsers = [ "${sigmaUser}" ];
          PasswordAuthentication = true;
          PermitRootLogin = lib.mkDefault "no";
          UseDns = true;
          X11Forwarding = false;
        };
      };
    })
  ];
}
