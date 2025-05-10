{
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (pkgs) amneziawg-tools amneziawg-go;
  awgCmd = arg: "sudo " + lib.getExe' amneziawg-tools "awg-quick" + " ${arg} warp";

  cfg = config.module.programs.amneziawg;
  include = config.module.include;
in
{
  options = {
    module.programs.amneziawg = {
      enable = lib.mkEnableOption "amnezia wg" // {
        default = include.surf;
      };
      service.enable = lib.mkEnableOption "amnezia wg service";
      config = lib.mkOption {
        type = lib.types.path;
        default = ./warp.conf;
      };
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      boot.extraModulePackages = with config.boot.kernelPackages; [ amneziawg ];
      # awg-quick uses resolveconf when creating interface
      services.resolved.enable = true;
      environment.systemPackages = [
        amneziawg-tools
        amneziawg-go
      ];
    })

    (lib.mkIf cfg.service.enable {
      environment.etc."amnezia/amneziawg/warp.conf".source = cfg.config;
      systemd.services.warp = {
        enable = true;
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        path = [ amneziawg-go ];
        serviceConfig = {
          Type = "oneshot";
          Restart = "on-failure";
          RestartSec = "5s";
          ExecStart = awgCmd "up";
          ExecStop = awgCmd "down";
          RemainAfterExit = "yes";
        };
      };
    })
  ];
}
