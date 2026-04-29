{ self, ewhs, ... }:
{
  flake.modules.nixos.homelab-jellyfin =
    { config, pkgs-unstable, ... }:
    {
      services.jellyfin = {
        enable = true;
        package = pkgs-unstable.jellyfin;
        user = "eweishaar";
        group = "users";
      };
      services.nginx.virtualHosts."jellyfin.ewhomelab.com" = ewhs.lib.mkProxyVirtualHost {
        port = 8096;
      };
      services.restic.backups.jellyfin = {
        repository = "sftp:root@10.0.0.8:/mnt/AuxPool/K8S-NFS/backups/jellyfin";
        paths = [ config.services.jellyfin.dataDir ];
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
