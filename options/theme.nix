{
  pkgs,
  config,
  lib,
  resourcePath,
  ...
}:
let
  option = default: lib.mkOption { inherit default; };
in
{
  options.module.theme = {
    package = option pkgs.kdePackages.breeze-gtk;
    name = option "Breeze-Dark";

    iconTheme = {
      package = option pkgs.kdePackages.breeze-icons;
      name = option "breeze-dark";
    };

    cursor = {
      package = option pkgs.material-cursors;
      name = option "material_cursors";
      size = option 32;
      sizeStr = option (builtins.toString config.module.theme.cursor.size);
    };

    font = {
      text = {
        package = option pkgs.noto-fonts;
        name = option "Noto Sans";
        size = option 10;
      };

      mono = {
        package = option pkgs.hack-font;
        packageNerd = option pkgs.nerd-fonts.hack;
        name = option "Hack";
        size = option 10;
      };
    };

    wallpaper = {
      displayManager = option (resourcePath + "/wallpapers/resonance.webp");
    };
  };
}
