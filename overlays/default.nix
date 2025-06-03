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
  };
}
