{ self, ewhs, ... }:
{
  flake.modules.nixos.homelab-radicale =
    { config, pkgs-unstable, ... }:

    {
      age.secrets = {
        radicale-users = {
          file = builtins.toPath "${self.outPath}/secrets/radicale-users.age";
          owner = config.systemd.services.radicale.serviceConfig.User;
          group = config.systemd.services.radicale.serviceConfig.Group;
        };
      };
      services.radicale = {
        enable = true;
        package = pkgs-unstable.radicale;
        settings = {
          server = {
            hosts = [ "0.0.0.0:5232" ];
          };
          auth = {
            type = "htpasswd";
            htpasswd_filename = config.age.secrets.radicale-users.path;
            htpasswd_encryption = "plain";
          };
          storage = {
            filesystem_folder = "/var/lib/radicale/collections";
          };
        };
      };
      services.gatus.settings.endpoints = [
        (ewhs.lib.mkGatusEndpoint {
          name = "radicale";
          url = "https://radicale.ewhomelab.com";
          conditions = [
            "[STATUS] < 500"
            "[RESPONSE_TIME] < 300"
          ];
        })
      ];
      services.nginx.virtualHosts."radicale.ewhomelab.com" = ewhs.lib.mkProxyVirtualHost {
        port = 5232;
      };
      services.restic.backups.radicale = ewhs.lib.mkResticBackup {
        name = "radicale";
        paths = [ config.services.radicale.settings.storage.filesystem_folder ];
        passwordFile = config.age.secrets.restic-password.path;
      };
    };
}
