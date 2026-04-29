{ self, ewhs, ... }:
{
  flake.modules.nixos.homelab-sonarr =
    { config, pkgs-unstable, ... }:
    {
      services.sonarr = {
        enable = true;
        package = pkgs-unstable.sonarr;
        user = "eweishaar";
        group = "users";
      };
      services.nginx.virtualHosts."sonarr.ewhomelab.com" = ewhs.lib.mkProxyVirtualHost {
        port = config.services.sonarr.settings.server.port;
      };
      services.restic.backups.sonarr = ewhs.lib.mkResticBackup {
        name = "sonarr";
        paths = [ config.services.sonarr.dataDir ];
        passwordFile = config.age.secrets.restic-password.path;
      };
    };
}
