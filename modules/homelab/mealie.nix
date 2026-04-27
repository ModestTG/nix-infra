{ self, ... }:
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
      services.nginx.virtualHosts."recipes.ewhomelab.com" = {
        forceSSL = true;
        serverName = "recipes.ewhomelab.com";
        useACMEHost = "ewhomelab.com";
        locations."/" = {
          proxyPass = "http://localhost:${toString config.services.mealie.port}";
          proxyWebsockets = true;
        };
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
