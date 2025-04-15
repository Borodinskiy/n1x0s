{ config, lib, ... }:
{
  time = {
    timeZone = lib.mkDefault "Europe/Moscow";

    # Fix for time jump
    hardwareClockInLocalTime = config.module.include.windowsDualboot;
  };

  i18n = {
    supportedLocales = [
      "C.UTF-8/UTF-8"
      "en_US.UTF-8/UTF-8"
      "en_GB.UTF-8/UTF-8"
      "ru_RU.UTF-8/UTF-8"
    ];

    defaultLocale = "en_GB.UTF-8";
    inputMethod.enabled = null;
  };

  console.keyMap = "us";

  services.xserver.xkb = {
    layout = "us,ru";
    options = "grp:win_space_toggle,grp:caps_toggle,grp_led:scroll";
  };
}
