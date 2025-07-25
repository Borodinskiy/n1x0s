{ pkgs, ... }:
let
  databaseName = "photoprism";
in
{
  fileSystems."/var/lib/private/photoprism" = {
    device = "/run/media/user/drive_p/photoprism";
    options = [ "bind" ];
  };

  fileSystems."/var/lib/private/photoprism/originals" = {
    device = "/run/media/user/drive_p/photoprism/originals";
    options = [ "bind" ];
  };

  services.photoprism = {
    enable = true;
    originalsPath = "/var/lib/private/photoprism/originals";
    address = "127.0.0.1";
    settings = {
      PHOTOPRISM_ADMIN_USER = "borodinskiy";
      PHOTOPRISM_ADMIN_PASSWORD = "ThatIsToBeTrue";
      PHOTOPRISM_DEFAULT_LOCALE = "en";
      PHOTOPRISM_DATABASE_DRIVER = "mysql";
      PHOTOPRISM_DATABASE_NAME = databaseName;
      PHOTOPRISM_DATABASE_SERVER = "/run/mysqld/mysqld.sock";
      PHOTOPRISM_DATABASE_USER = databaseName;
    };
  };
  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
    ensureDatabases = [ databaseName ];
    ensureUsers = [
      {
        name = databaseName;
        ensurePermissions = {
          "${databaseName}.*" = "ALL PRIVILEGES";
        };
      }
    ];
  };
}
