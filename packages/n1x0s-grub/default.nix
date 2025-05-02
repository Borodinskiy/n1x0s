{
  lib,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation {
  pname = "n1x0s-grub";
  version = "1.0.0";

  src = ./src;

  installPhase = ''
    runHook preInstall
    
    mkdir -p "$out/"
    cp -r $src/* "$out/"

    runHook postInstall
  '';

  meta = {
    description = "N1X0S's grub theme";
    platforms = lib.platforms.linux;
  };
}
