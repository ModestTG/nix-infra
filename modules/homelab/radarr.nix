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
      services.nginx.virtualHosts."radarr.ewhomelab.com" = ewhs.lib.mkProxyVirtualHost {
        port = config.services.radarr.settings.server.port;
      };
      services.restic.backups.radarr = {
        repository = "sftp:root@10.0.0.8:/mnt/AuxPool/K8S-NFS/backups/radarr";
        paths = [ config.services.radarr.dataDir ];
        passwordFile = config.age.secrets.restic-password.path;
        initialize = true;
        pruneOpts = [
          "--keep-daily 14"
          "--keep-monthly 6"
          "--keep-yearly 1"
        ];
      };
    };
}
