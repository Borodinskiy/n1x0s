{
  pkgs,
  config,
  lib,
  ...
}:
{
  options.module.theme = {
    package = lib.mkOption { default = pkgs.kdePackages.breeze-gtk; };
    name = lib.mkOption { default = "Breeze-Dark"; };

    iconTheme = {
      package = lib.mkOption { default = pkgs.kdePackages.breeze-icons; };
      name = lib.mkOption { default = "breeze-dark"; };
    };

    cursor = {
      package = lib.mkOption { default = pkgs.material-cursors; };

      name = lib.mkOption { default = "material_cursors"; };

      size = lib.mkOption { default = 32; };

      sizeStr = lib.mkOption { default = builtins.toString config.module.theme.cursor.size; };
    };

    font = {
      text = {
        package = lib.mkOption { default = pkgs.noto-fonts; };

        name = lib.mkOption { default = "Noto Sans"; };

        size = lib.mkOption { default = 10; };

        sizeSwaylock = lib.mkOption { default = 10.0; };
      };

      mono = {
        package = lib.mkOption { default = pkgs.hack-font; };

        name = lib.mkOption { default = "Hack"; };

        size = lib.mkOption { default = 10; };

        sizeSway = lib.mkOption { default = 10.0; };
      };
    };
  };
}
