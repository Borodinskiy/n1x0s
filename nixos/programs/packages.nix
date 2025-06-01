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
  environment.systemPackages =
    with pkgs;
    [
      # Download files from network
      wget
      curl
      # Private network tools
      tor
      obfs4
      snowflake
      proxychains
      wireguard-tools
      openvpn
      # Searching
      ripgrep
      fd
      # Disk usage analysis
      ncdu
      # Common Internet File System support
      cifs-utils
      # Version control system
      git
      # Different archive formats
      zip
      unzip
      p7zip
      unar
      lzip
      # Terminal multiplexor
      tmux
      # Process monitor
      btop
      # Process ls
      psmisc
      lsof
      # Hardware info utils
      usbutils
      pciutils
      # Boot management
      efibootmgr
      # File manager
      yazi
    ]

    ++ lib.optionals group.develop [
      # Hex editor
      okteta
      godot_4
      vscodium
      # Locale generation utilities
      gettext

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
      # MSI Afterburner 2
      mangohud
      # Windows !emulator
      wineWowPackages.staging
      unstable.winetricks
      # Extract images from .ico/.exe files using icotool/wrestool
      icoutils
      # Manage custom steam Proton versions
      protonup

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

    ++ lib.optionals group.texlive [
      # All packages :/ 4GiB+
      texlive.combined.scheme-full
      # .text file formatter
      tex-fmt
    ]

    ++ lib.optionals group.office [
      libreoffice-still
      # Text hyphenation library
      hyphen
      # Language dictionary
      hunspell
      hunspellDicts.ru-ru
      hunspellDicts.uk-ua
      hunspellDicts.en-us
    ]

    ++ lib.optionals group.pentest [
      nmap

      ettercap # Sniffer for MiTM
      p0f # Passive network analysis and fingerprinting tool
      wireshark
      tcpdump
      ghidra
      jadx

      binwalk
      steghide
      stegseek # steganography files

      burpsuite # Network requests editor
      dirb # Sites directory scanning
      gobuster

      crunch # Wordlist generator
      hashcat # Hash bruteforce
    ]

    ++ lib.optionals group.redactor [
      # Musthave
      ffmpeg
      # Image
      krita
      gimp
      # Render
      kdePackages.kdenlive
      frei0r
      glaxnimate
      # Audio render
      audacity
      # 3D modeling software
      blender
    ]

    ++ lib.optionals group.surf [
      # Calculator
      speedcrunch
      # Media players
      (mpv-unwrapped.wrapper {
        scripts = with pkgs.mpvScripts; [
          # Media player support in desktop environments
          mpris
        ];
        mpv = pkgs.mpv-unwrapped.override {
          waylandSupport = true;
        };
      })
      vlc
      # Browsers
      tor-browser
      librewolf
      qutebrowser
      # BitTorrent
      qbittorrent
      # Notes
      obsidian
      # For calls
      telegram-desktop
      discord
      simplex-chat-desktop
      # Private chat
      # Voice client
      mumble
      # Shazam music recognition frontend
      songrec
    ]

    # Helper tools for wayland compositors
    ++ lib.optionals group.wmTools [
      # Applications menu
      wofi
      # Notification daemon
      mako
      # cli
      pamixer
      playerctl
      # GUI for sound mixer
      pavucontrol
      # Screenshot tools (screenshooter and area picker)
      grim
      slurp
      # Color picker
      hyprpicker
      # Clipboard daemon and history storage
      wl-clipboard
      cliphist
      # Status bar
      waybar
      # Applets
      networkmanagerapplet
      # Wallpaper tools
      swaybg
      waypaper
      # GUI for display management in wlroots-like compositors
      wdisplays
    ];
}
