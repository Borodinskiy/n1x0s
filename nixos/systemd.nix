{
  systemd = {
    settings.Manager = {
      DefaultTimeoutStopSec = 34;
    };

    sleep.extraConfig = ''
      AllowSuspend=yes
      AllowHibernation=no
      AllowHybridSleep=no
      AllowSuspendThenHibernate=no
    '';
  };
}
