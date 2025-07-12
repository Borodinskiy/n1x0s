{ inputs, ... }:
{
  custom = final: _prev: import ../packages final.pkgs;

  unstable = final: _prev: {
    unstable = import inputs.unstable {
      system = final.system;
    };
  };

  overrides =
    {
      cudaSupport,
      hipSupport,
    }:
    let
      gpuComputingSupport = {
        inherit cudaSupport hipSupport;
      };
    in
    final: prev: {
      mpv = prev.mpv-unwrapped.wrapper {
        mpv = prev.mpv-unwrapped;
        scripts = with prev.mpvScripts; [
          # Media player support in desktop environments
          mpris
        ];
      };

      # Disable browser (libcef) support because it's lib takes 1.5GiB of useless function in obs for me
      obs-studio = prev.obs-studio.override {
        browserSupport = false;
        inherit cudaSupport;
      };

      blender = prev.blender.override gpuComputingSupport;
      openimagedenoise = prev.openimagedenoise.override { inherit cudaSupport; };
      opensubdiv = prev.opensubdiv.override { inherit cudaSupport; };

      # FIXME: gconf baked file because of removed 2to3 thing in next fucking python update so bread...
      # https://github.com/NixOS/nixpkgs/issues/413845
      gnome2.GConf = prev.gnome2.GConf.overrideAttrs (old: {
        postPatch =
          let
            path = ./gconf/gsettings-schema-convert;
          in
          ''
              cp "${path}" gsettings/gsettings-schema-convert
          '';
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
