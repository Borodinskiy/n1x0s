{
  pkgs,
  config,
  lib,
  ...
}:
let
  group = config.module.include;
in
{
  home.packages =
    with pkgs;
    lib.optionals group.develop [
      # Cli utility for getting info about mediafiles
      mediainfo
      # Download videos from url
      yt-dlp
      # Adb/fastboot for android device debugging, removing shit, reinstalling shindows and removing [company] software
      android-tools
      # Dependency of Lazy nvim plugin manager
      lua5_1
      lua51Packages.luarocks
      # Clipboard support for wayland
      wl-clipboard
      cliphist
      # Language servers

      # Lua
      lua-language-server
      # Bash
      bash-language-server
      # Nix
      nixd
      nixfmt-rfc-style
      # Css/json/... extracted from vscode
      vscode-langservers-extracted
    ]

    ++ lib.optionals group.gaming [
      # Compositor in a window
      gamescope
      # Windows !emulator
      #wineWowPackages.staging
      #unstable.winetricks
      # Extract images from .ico/.exe files using icotool/wrestool
      icoutils

      # Minecraft
      #portablemc atlauncher
      (prismlauncher.override {
        jdks = [
          jdk8
          jdk17
          jdk
        ];
      })
      # Playstation
      #duckstation
      # Playstation 2
      #pcsx2
      # Gamecube/Wii
      #dolphin-emu
    ]

    ++ lib.optionals group.surf [
      # Vibrowser
      qutebrowser
      # Private chat
      #simplex-chat-desktop
      # Voice client
      mumble
      # Shazam music recognition frontend
      songrec
    ];
}
