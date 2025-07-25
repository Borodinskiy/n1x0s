{
  config,
  lib,
  resourcePath,
  ...
}:
let
  serviceConfigPath = resourcePath + "/sing-box.json";
  cfg = config.module.purpose.home;
in
{
  config = lib.mkIf (cfg && builtins.pathExists serviceConfigPath) {
    services.sing-box = {
      enable = true;
      settings = builtins.fromJSON (builtins.readFile serviceConfigPath);
    };
  };
}
