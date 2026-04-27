{ self, ... }:
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
      services.nginx.virtualHosts."radicale.ewhomelab.com" = {
        forceSSL = true;
        serverName = "radicale.ewhomelab.com";
        useACMEHost = "ewhomelab.com";
        locations."/" = {
          proxyPass = "http://localhost:5232";
          proxyWebsockets = true;
        };
      };
      services.restic.backups.radicale = {
        repository = "sftp:root@10.0.0.8:/mnt/AuxPool/K8S-NFS/backups/radicale";
        paths = [ config.services.radicale.settings.storage.filesystem_folder ];
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
