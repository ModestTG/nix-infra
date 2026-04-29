{ self, ... }:
{
  flake.modules.nixos.homelab-sonarr =
    { config, homeLab, pkgs-unstable, ... }:
    {
      services.sonarr = {
        enable = true;
        package = pkgs-unstable.sonarr;
        user = "eweishaar";
        group = "users";
      };
      services.nginx.virtualHosts."sonarr.ewhomelab.com" = homeLab.mkProxyVirtualHost {
        port = config.services.sonarr.settings.server.port;
      };
      services.restic.backups.sonarr = {
        repository = "sftp:root@10.0.0.8:/mnt/AuxPool/K8S-NFS/backups/sonarr";
        paths = [ config.services.sonarr.dataDir ];
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
