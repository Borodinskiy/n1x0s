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

      ncdu # Disk usage analysis
      cifs-utils # Common Internet File System support
      git # Version control system
      tmux # Terminal multiplexor
      btop # Process monitor
      yazi # Cli file manager
      efibootmgr # UEFI boot entry management

      # Different archive formats
      zip
      unzip
      p7zip
      unar
      lzip

      # Process ls
      psmisc
      lsof

      # Hardware info utils
      usbutils
      pciutils
    ]

    ++ lib.optionals group.develop [
      foot # Terminal
      okteta # Hex editor
      godot_4 # Game engine
      vscodium # IDE Browser 229
      gettext # Locale generation utilities
      mediainfo # Cli utility for getting info about mediafiles
      yt-dlp # Download videos from url
      android-tools # Adb/fastboot for android device debugging, removing shit, reinstalling shindows and removing [company] software

      # Dependency of Lazy nvim plugin manager
      lua5_1
      lua51Packages.luarocks

      # Clipboard support for wayland
      wl-clipboard
      cliphist

      # Language servers and etc.
      lua-language-server # Lua
      bash-language-server # Bash
      nixd # Nix
      nixfmt-rfc-style # Nix code formatter
      treefmt # Autoformat of code files
      vscode-langservers-extracted # Css/json/... extracted from vscode
    ]

    ++ lib.optionals group.gaming [
      gamescope # Compositor in a window
      mangohud # MSI Afterburner 2
      wineWowPackages.staging # Windows !emulator
      unstable.winetricks # Script to install windows DLLs
      icoutils # Extract images from .ico/.exe files using icotool/wrestool
      protonup # Manage custom steam Proton versions
      prismlauncher # Minecraft launcher
    ]

    ++ lib.optionals group.texlive [
      texlive.combined.scheme-full # All packages :/ 4GiB+
      tex-fmt # .text file formatter
    ]

    ++ lib.optionals group.office [
      libreoffice-still
      hyphen # Text hyphenation library

      # Language dictionaries and tools
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

      # steganography files
      binwalk
      steghide
      stegseek

      burpsuite # Network requests editor
      dirb # Sites directory scanning
      gobuster

      crunch # Wordlist generator
      hashcat # Hash bruteforce
    ]

    ++ lib.optionals group.redactor [
      ffmpeg # Musthave
      audacity # Audio render
      blender # 3D modeling software

      # Image
      krita
      gimp

      # Render
      kdePackages.kdenlive
      frei0r
      glaxnimate
    ]

    ++ lib.optionals group.surf [
      # Browsers
      tor-browser
      librewolf
      qutebrowser
      qbittorrent

      speedcrunch # Calculator
      obsidian # Notes
      songrec # Shazam music recognition frontend

      # Media players
      mpv

      # For calls
      telegram-desktop
      discord
      simplex-chat-desktop
      mumble
    ]

    # Helper tools for wayland compositors
    ++ lib.optionals group.wmTools [
      wofi # Applications menu
      mako # Notification daemon
      waybar # Status bar
      wdisplays # GUI for display management in wlroots-like compositors
      hyprpicker # Color picker
      pavucontrol # GUI for sound mixer

      # cli
      pamixer
      playerctl

      # Screenshot tools (screenshooter and area picker)
      grim
      slurp

      # Clipboard daemon and history storage
      wl-clipboard
      cliphist

      # Applets
      networkmanagerapplet

      # Wallpaper tools
      swaybg
      waypaper
    ]

    # Theme packages
    ++ (with config.module.theme; [
      package
      iconTheme.package
      cursor.package
    ]);
}
