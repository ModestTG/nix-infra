{ self, ewhs, ... }:
{
  flake.modules.nixos.homelab-mealie =
    { config, pkgs-unstable, ... }:
    {
      services.mealie = {
        enable = true;
        package = pkgs-unstable.mealie;
        settings = {
          BASE_URL = "recipes.ewhomelab.com";
        };
      };
      services.nginx.virtualHosts."recipes.ewhomelab.com" = ewhs.lib.mkProxyVirtualHost {
        port = config.services.mealie.port;
      };
      services.restic.backups.mealie = {
        repository = "sftp:root@10.0.0.8:/mnt/AuxPool/K8S-NFS/backups/mealie";
        paths = [ "/var/lib/mealie" ];
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
