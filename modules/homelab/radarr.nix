{ self, ewhs, ... }:
{
  flake.modules.nixos.homelab-radarr =
    { config, pkgs-unstable, ... }:
    {
      services.radarr = {
        enable = true;
        package = pkgs-unstable.radarr;
        user = "eweishaar";
        group = "users";
        settings = {
          auth = {
            authenticationmethod = "Forms";
          };
        };
      };
      services.gatus.settings.endpoints = [
        (ewhs.lib.mkGatusEndpoint {
          name = "radarr";
          url = "https://radarr.ewhomelab.com";
        })
      ];
      services.nginx.virtualHosts."radarr.ewhomelab.com" = ewhs.lib.mkProxyVirtualHost {
        port = config.services.radarr.settings.server.port;
      };
      services.restic.backups.radarr = ewhs.lib.mkResticBackup {
        name = "radarr";
        paths = [ config.services.radarr.dataDir ];
        passwordFile = config.age.secrets.restic-password.path;
      };
    };
}
