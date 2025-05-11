{
  lib,
  stdenvNoCC,
  name ? "example",
  command ? "echo \"Hello world\"",
}:
stdenvNoCC.mkDerivation {
  pname = "n1x0s-session";
  version = "1.0.0";

  # Instead of actually unpacking, calling binary "true"
  # which returns exit code 0 (success)
  unpackPhase = "true";

  installPhase = ''
    runHook preInstall
    
    mkdir -p "$out/share/wayland-sessions"

    cat << EOF > "$out/share/wayland-sessions/n1x0s-${name}.desktop"
[Desktop Entry]
Name=${name}
Comment=Custom n1x0s session
Exec=${command}
TryExec=${command}
Type=Application
EOF

    runHook postInstall
  '';

  passthru.providedSessions = [ "n1x0s-${name}" ];

  meta = {
    description = "N1X0S's package for creating custom displayManager session";
    platforms = lib.platforms.linux;
  };
}
