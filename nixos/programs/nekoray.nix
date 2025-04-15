{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.module.include.surf;
in
{
  config = lib.mkIf cfg {
    environment.systemPackages = with pkgs; [
      # sing-box/xray client
      nekoray
    ];
    # Also needed for properly working tun in nekoray
    security.wrappers = {
      nekobox_core = {
        owner = "root";
        group = "root";
        source = "${pkgs.nekoray.nekobox-core}/bin/nekobox_core";
        capabilities = "cap_net_admin=ep";
      };
    };
  };
}
