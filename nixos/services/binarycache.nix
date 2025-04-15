{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.module.include.binaryCache;
in
{
  config = lib.mkIf cfg {
    services.nix-serve = {
      enable = true;
      secretKeyFile = "/var/binarycache/cache-pub-key.pem";
    };

    nix.settings.secret-key-files = [
      "/var/binarycache/cache-pub-key.pem"
    ];

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
