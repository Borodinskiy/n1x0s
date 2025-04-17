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
    ]

    ++ lib.optionals group.develop [
      # Hex editor
      okteta
      godot_4
      vscodium
    ]

    ++ lib.optionals group.gaming [
    ]

    ++ lib.optionals group.office [
      libreoffice-still
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
      binwalk
      steghide
      stegseek # steganography files
      burpsuite # Network requests editor
      metasploit
      dirb
      gobuster
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
      # Work with 3D cloud
      cloudcompare
      # 3D modeling software
      (pkgs.blender.override { cudaSupport = config.module.driver.gpu.nvidia; })
    ]

    ++ lib.optionals group.surf [
      # Calculator
      speedcrunch
      # Media players
      mpv
      vlc
      # Browsers
      tor-browser
      librewolf
      # BitTorrent
      qbittorrent
      # Notes
      obsidian
      # For calls
      telegram-desktop
    ]

    # Helper tools for wayland compositors";
    ++ lib.optionals group.wmTools [
      # Idle daemon & lockscreen
      swayidle
      swaylock
      # Applications menu
      wofi
      # Notification daemon
      mako
      # Sound and brightness cli
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

  fonts.packages =
    with pkgs;
    lib.optionals group.fonts [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      liberation_ttf
      comic-mono
      (nerdfonts.override {
        fonts = [
          "NerdFontsSymbolsOnly"
          config.module.theme.font.mono.name
        ];
      })
      # MS .docx compatibility
      corefonts
      vistafonts
    ];
}
