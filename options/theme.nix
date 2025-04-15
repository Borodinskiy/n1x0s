{
  pkgs,
  config,
  lib,
  ...
}:
{
  options.module.theme = {
    cursor = {
      package = lib.mkOption { default = pkgs.kdePackages.breeze; };

      name = lib.mkOption { default = "Breeze_Light"; };

      size = lib.mkOption { default = 36; };

      sizeStr = lib.mkOption { default = builtins.toString config.module.theme.cursor.size; };
    };

    font = {
      text = {
        package = lib.mkOption { default = pkgs.noto-fonts; };

        name = lib.mkOption { default = "Noto Sans"; };

        size = lib.mkOption { default = 12; };

        sizeSwaylock = lib.mkOption { default = 14.0; };
      };

      mono = {
        package = lib.mkOption { default = pkgs.hack-font; };

        name = lib.mkOption { default = "Hack"; };

        size = lib.mkOption { default = 12; };

        sizeSway = lib.mkOption { default = 12.0; };
      };
    };
  };
}
