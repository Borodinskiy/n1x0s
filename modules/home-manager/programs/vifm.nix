{ config, ... }:
let
  cfg = config.home.sessionVariables;
in
{
  programs.vifm = {
    enable = true;
    extraConfig = # vim
      ''
        mark b ${cfg.HOME_WORKSPACE}/bin
        mark d /run/media/${config.home.username}
        mark s ${cfg.HOME_MYFILES}/sync
        mark u ${cfg.HOME_MYFILES}/sync/unik
        mark w ${cfg.HOME_WORKSPACE}
        mark m ${cfg.HOME_MYFILES}/music/epicfail
        mark h ~
        mark H ${cfg.HOME_MYFILES}
        mark r /
        mark C /mnt/c
        mark D /mnt/d
        mark E /mnt/e
        mark F /mnt/f
        mark G /mnt/g
        mark P /mnt/p
        mark R /mnt/c

        source ${cfg.HOME_WORKSPACE}/config/vifm/modules/devicons.vifm
        source ${cfg.HOME_WORKSPACE}/config/vifm/modules/main.vifm
      '';
  };
}
