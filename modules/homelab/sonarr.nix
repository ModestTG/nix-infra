{ self, ... }:
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
      services.nginx.virtualHosts."sonarr.ewhomelab.com" = {
        forceSSL = true;
        serverName = "sonarr.ewhomelab.com";
        useACMEHost = "ewhomelab.com";
        locations."/" = {
          proxyPass = "http://localhost:${toString config.services.sonarr.settings.server.port}";
          proxyWebsockets = true;
        };
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
