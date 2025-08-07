{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.module.include.gaming;
in
{
  # Compatibility tool for non-NixOS linux binaries
  config = lib.mkIf cfg {
    programs.nix-ld = {
      enable = true;
      libraries = with pkgs; [
        # List by default
        acl
        attr
        bzip2
        curl
        libsodium
        libssh
        libxml2
        openssl
        stdenv.cc.cc.lib
        systemd
        util-linux
        xz
        zlib
        zstd

        # My own additions
        libGL
        libelf
        libva
        pipewire
        xorg.libX11
        xorg.libXcomposite
        xorg.libXdamage
        xorg.libXext
        xorg.libXfixes
        xorg.libXrandr
        xorg.libXtst
        xorg.libXxf86vm
        xorg.libxcb
        xorg.libxshmfence
        e2fsprogs # libcom_err.so.2

        # Required
        glib
        gtk2

        # Inspired by steam
        # https://github.com/NixOS/nixpkgs/blob/master/pkgs/by-name/st/steam/package.nix#L36-L85
        # glibc_multi.bin # Seems to cause issue in ARM
        coreutils
        libdrm
        libgbm
        libxcrypt
        networkmanager
        pciutils
        vulkan-loader
        zenity

        # # Without these it silently fails
        SDL2
        cups
        dbus-glib
        ffmpeg
        gnome2.GConf
        libcap
        libudev0-shim # Only libraries are needed from those two
        libusb1
        nspr
        nss
        xorg.libICE
        xorg.libSM
        xorg.libXScrnSaver
        xorg.libXcursor
        xorg.libXi
        xorg.libXinerama
        xorg.libXrender

        # needed to run unity
        gsettings-desktop-schemas
        gtk3
        icu
        libnotify
        # https://github.com/NixOS/nixpkgs/issues/72282
        # https://github.com/NixOS/nixpkgs/blob/2e87260fafdd3d18aa1719246fd704b35e55b0f2/pkgs/applications/misc/joplin-desktop/default.nix#L16
        # log in /home/leo/.config/unity3d/Editor.log
        # it will segfault when opening files if you don’t do:
        # export XDG_DATA_DIRS=/nix/store/0nfsywbk0qml4faa7sk3sdfmbd85b7ra-gsettings-desktop-schemas-43.0/share/gsettings-schemas/gsettings-desktop-schemas-43.0:/nix/store/rkscn1raa3x850zq7jp9q3j5ghcf6zi2-gtk+3-3.24.35/share/gsettings-schemas/gtk+3-3.24.35/:$XDG_DATA_DIRS
        # other issue: (Unity:377230): GLib-GIO-CRITICAL **: 21:09:04.706: g_dbus_proxy_call_sync_internal: assertion 'G_IS_DBUS_PROXY (proxy)' failed

        # Verified games requirements
        SDL
        SDL2_image
        glew110
        libidn
        libogg
        libvorbis
        tbb
        xorg.libXmu
        xorg.libXt

        # Other things from runtime
        SDL2_mixer
        SDL2_ttf
        SDL_image
        SDL_mixer
        SDL_ttf
        flac
        freeglut
        libappindicator-gtk2
        libcaca
        libcanberra
        libdbusmenu-gtk2
        libgcrypt
        libindicator-gtk2
        libjpeg
        libmikmod
        harfbuzz
        libpng
        libpng12
        librsvg
        libsamplerate
        libtheora
        libtiff
        libvdpau
        libvpx
        pixman
        speex
        xorg.libXft
        # ...
        # Some more libraries that I needed to run programs
        alsa-lib
        atk
        cairo
        dbus
        expat
        fontconfig
        freetype
        gdk-pixbuf
        libxkbcommon # For blender
        pango

        # For natron
        libGLU
        libxcrypt-legacy
      ];
    };
  };
}
