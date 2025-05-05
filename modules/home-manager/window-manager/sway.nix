{ config, lib, ... }:
let
  cfg = config.module.de.sway;
in
{
  config = lib.mkIf cfg.enable {
    home.sessionVariables = {
      # For icc colorprofiles support
      # TODO: Check when this will became stable
      #WLR_RENDERER="vulkan";
    };
    # Fix kde's xdg portal menus application demencia (in dolphin as an example)
    home.activation.linkKdeMenusToSway = # bash
      ''
        link() {
          in="$1"
          out="$2"
          if [ "$(realpath "$in")" != "$(realpath "$out")" ]; then
            run mkdir -p "$(dirname "$out")"
            run ln -sf "$in" "$out"
          fi
        }
        link \
          /run/current-system/sw/etc/xdg/menus/plasma-applications.menu \
          ~/.config/menus/applications.menu
      '';
  };
}
