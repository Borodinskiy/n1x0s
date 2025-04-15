{
  pkgs,
  config,
  lib,
  sigmaUser,
  ...
}:
let
  cfg = config.module.de.hyprland;
in
{
  config = lib.mkIf cfg.enable {
    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
      withUWSM = true;
    };

    module.include.wmTools.enable = true;

    # Idle daemon for actions like lockscreen
    services.hypridle.enable = true;
    # Lockscreen
    programs.hyprlock.enable = true;

    services.gnome.gnome-keyring.enable = true;

    programs.light.enable = true;
    users.extraGroups.video.members = [ "${sigmaUser}" ];

    environment.systemPackages = with pkgs; [
      # Applications menu
      wofi
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
      hyprpaper
      swaybg
      waypaper
      # GUI for display management in wlroots-like compositors
      wdisplays
      # Stream wayland windows to X apps
      xwaylandvideobridge
    ];
  };
}
