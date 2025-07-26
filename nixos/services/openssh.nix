{
  config,
  lib,
  sigmaUser,
  ...
}:
let
  cfg = config.module.purpose;
  autostart = config.module.openssh.autostart;
in
{
  options = {
    module.openssh.autostart = lib.mkEnableOption "autostart ssh service";
  };
  config = lib.mkMerge [
    # Disable service autostart on home machines
    (lib.mkIf (cfg.home && !autostart) {
      systemd.services.sshd.wantedBy = lib.mkForce [ ];
    })

    {
      services.openssh = {
        enable = true;

        openFirewall = cfg.server || autostart;
        ports = [ 40242 ];

        settings = {
          AllowUsers = [ sigmaUser ];
          PasswordAuthentication = cfg.home;
          PermitRootLogin = lib.mkDefault "no";
          UseDns = true;
          X11Forwarding = false;
        };
      };
    }
  ];
}
