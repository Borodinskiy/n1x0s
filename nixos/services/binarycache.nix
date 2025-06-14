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

      virtualHosts."${config.networking.hostName}" =
        let
          address = config.services.nix-serve.bindAddress;
          port = toString config.services.nix-serve.port;
        in
        {
          locations."/" = {
            proxyPass = "http://${address}:${port}";
          };
        };
    };
  };
}
