{ inputs, ... }:
{
  custom = final: _prev: import ../packages final.pkgs;

  unstable = final: _prev: {
    unstable = import inputs.unstable {
      system = final.system;
    };
  };

  fixmes = final: prev: {
    # FIXME: mpv video decoding not work. Will be fixed after next update of flake inputs
    mpv-unwrapped = prev.mpv-unwrapped.override {
      libplacebo = final.libplacebo-mpv;
    };
    libplacebo-mpv =
      let
        version = "7.349.0";
      in
      prev.libplacebo.overrideAttrs (old: {
        inherit version;
        src = prev.fetchFromGitLab {
          domain = "code.videolan.org";
          owner = "videolan";
          repo = "libplacebo";
          rev = "v${version}";
          hash = "sha256-mIjQvc7SRjE1Orb2BkHK+K1TcRQvzj2oUOCUT4DzIuA=";
        };
      });

    # Hides foot server and client desktop entries from application menus in DEs
    # This version doesn't present in binary cache but don't care because foot compilation takes 5 sec
    foot = prev.foot.overrideAttrs (old: {
      postInstall =
        old.postInstall
        + ''
          rm $out/share/applications/foot-server.desktop
          rm $out/share/applications/footclient.desktop
        '';
    });
  };
}
