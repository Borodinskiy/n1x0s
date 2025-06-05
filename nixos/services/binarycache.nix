{
  config,
  lib,
  ...
}:
let
  cfg = config.module.include.binaryCacheServer;
in
{
  config = lib.mkIf cfg {
    services.nix-serve.enable = true;

    networking.firewall.allowedTCPPorts = [
      config.services.nginx.defaultHTTPListenPort
    ];

    services.nginx = {
      enable = true;

      recommendedProxySettings = true;

      virtualHosts."${config.networking.hostName}" = {
        locations."/" = {
          proxyPass = "http://${config.services.nix-serve.bindAddress}:${toString config.services.nix-serve.port}";
        };
      };
    };
  };
}
