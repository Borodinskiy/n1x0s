{ config, lib, ... }:
let
  cfg = config.module.de.hyprland;
in
{
  config = lib.mkIf cfg.enable {
    home.activation.linkKdeMenusToHyprland = # bash
      ''
        link() {
          in="$1"
          out="$2"
          if [ "$(realpath "$in")" != "$(realpath "$out")" ]; then
            run mkdir -p "$(dirname "$out")"
            run ln -sf "$in" "$out"
          fi
        }
        # Bullshit for proper dolphin file manager Hyprland support
        link \
          /run/current-system/sw/etc/xdg/menus/plasma-applications.menu \
          ~/.config/menus/Hyprland-applications.menu
      '';
  };
}
