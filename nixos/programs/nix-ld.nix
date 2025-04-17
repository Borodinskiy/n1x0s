{ pkgs, config, lib, ... }:
let
  cfg = config.module.include.gaming;
in
{
  # Compatibility tool for non-NixOS linux binaries
  config = lib.mkIf cfg {
    programs.nix-ld = {
      enable = true;
      libraries = with pkgs; [
        # Libc
        stdenv.cc.cc.lib
        libGL
        libGLU
        # SDL
        SDL
        SDL_image
        SDL_sound
        SDL_mixer
        SDL_ttf
        # SDL2
        SDL2
        SDL2_image
        SDL2_sound
        SDL2_mixer
        SDL2_ttf
        # Xorg
        xorg.libX11
        xorg.libXext
        xorg.libXinerama
        xorg.libXrandr
        xorg.libXcursor
        xorg.libxcb
        xorg.libSM
        xorg.libICE
        # GTK
        gtk2-x11
        gtk3-x11
        glib
        gobject-introspection
        # Sound
        alsa-lib
        libpulseaudio
        # Fonts
        freetype
        wayland-utils
        wayland
        waylandpp
        # Etc
        zlib
        # C#
        dotnet-runtime_8
        icu
        fontconfig
        xorg.libICE
        xorg.libSM
        dbus
        curl
        gnutls
        libgnurl
        glib
        pango
        cairo
        gdk-pixbuf
      ];
    };
  };
}
