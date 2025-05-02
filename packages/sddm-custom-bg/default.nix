{
  pkgs,
  lib,
  stdenvNoCC,
  themeConfig ? null,
}:
stdenvNoCC.mkDerivation rec {
  pname = "sddm-custom-bg";
  version = "1.0";

  src = ./src;

  dontWrapQtApps = true;
  propagatedBuildInputs = with pkgs.kdePackages; [
    qt5compat
    qtsvg
  ];

  installPhase =
    let
      iniFormat = pkgs.formats.ini { };
      configFile = iniFormat.generate "" { General = themeConfig; };

      basePath = "$out/share/sddm/themes/sddm-custom-bg";
    in
    ''
      mkdir -p ${basePath}
      cp -r $src/* ${basePath}
    ''
    + lib.optionalString (themeConfig != null) ''
      ln -sf ${configFile} ${basePath}/theme.conf.user
    '';

  meta = {
    description = "Custom looking qt6 sddm theme";
    homepage = "BORODINSKIY XD ))00)))))";
    license = lib.licenses.gpl3;

    platforms = lib.platforms.linux;
  };
}
