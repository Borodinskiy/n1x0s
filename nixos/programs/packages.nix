{
  pkgs,
  config,
  lib,
  ...
}:
let
  group = config.module.include;
  purp = config.module.purpose;
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

    ++ lib.optionals purp.home [
      foot # Terminal

      # Clipboard support for wayland
      wl-clipboard
      cliphist
    ]

    # Theme packages
    ++ lib.optionals purp.home (
      with config.module.theme;
      [
        package
        iconTheme.package
        cursor.package
      ]
    )

    ++ lib.optionals group.develop [
      okteta # Hex editor
      godot_4 # Game engine
      vscodium # IDE Browser 229
      gettext # Locale generation utilities
      mediainfo # Cli utility for getting info about mediafiles
      yt-dlp # Download videos from url
      android-tools # Adb/fastboot for android device debugging, removing shit, reinstalling shindows and removing [company] software

      # Language servers and etc.
      lua-language-server # Lua
      bash-language-server # Bash
      nixd # Nix
      vscode-langservers-extracted # Css/json/... extracted from vscode

      nixfmt-rfc-style # Nix code formatter
      treefmt # Autoformat of code files
    ]

    ++ lib.optionals group.gaming [
      gamescope # Compositor in a window
      mangohud # MSI Afterburner 2
      umu-launcher # Steam runtime without steam
      unstable.winetricks # Script to install windows DLLs
      icoutils # Extract images from .ico/.exe files using icotool/wrestool
      protonup # Manage custom steam Proton versions
      prismlauncher # Minecraft launcher
    ]

    ++ lib.optionals group.texlive [
      texlive.combined.scheme-full # All packages :/ 4GiB+
      tex-fmt # .tex file formatter
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

      # Steganography files
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
      gimp3

      # Render
      kdePackages.kdenlive
      frei0r
      glaxnimate
    ]

    ++ lib.optionals group.surf [
      # V[M/L]ess, shadowsocks, etc. client
      sing-box

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

      # Cli
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
    ];
}
