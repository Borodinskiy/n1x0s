{ config, lib, ... }:
{
  time = {
    timeZone = lib.mkDefault "Europe/Moscow";

    # Fix for time jump
    hardwareClockInLocalTime = config.module.include.windowsDualboot;
  };

  i18n = {
    supportedLocales = [
      "en_US.UTF-8/UTF-8"
      "en_GB.UTF-8/UTF-8"
      "ru_RU.UTF-8/UTF-8"
    ];

    defaultLocale = lib.mkDefault "en_GB.UTF-8";
    inputMethod.enabled = null;
  };

  console.useXkbConfig = true;

  services.xserver.xkb = {
    layout = lib.mkDefault "us,ru";
    options = "grp:win_space_toggle,grp:caps_toggle,grp_led:scroll";
  };
}
