{ self, ewhs, ... }:
{
  flake.modules.nixos.homelab-paperless-ngx =
    { config, pkgs-unstable, ... }:

    {
      age.secrets.paperless-ngx-admin-password = {
        file = builtins.toPath "${self.outPath}/secrets/paperless-ngx-admin-password.age";
        owner = config.services.paperless.user;
      };
      services.paperless = {
        enable = true;
        package = pkgs-unstable.paperless-ngx;
        passwordFile = config.age.secrets.paperless-ngx-admin-password.path;
        configureTika = true;
        domain = "docs.ewhomelab.com";
        address = "0.0.0.0";
        settings = {
          PAPERLESS_ADMIN_USER = "eweishaar";
          PAPERLESS_FILENAME_FORMAT = "{{ created_year }}/{{ correspondent }}/{{ title }}";
        };
      };
      services.nginx.virtualHosts."docs.ewhomelab.com" = ewhs.lib.mkProxyVirtualHost {
        port = config.services.paperless.port;
      };
      services.restic.backups.paperless-ngx = {
        repository = "sftp:root@10.0.0.8:/mnt/AuxPool/K8S-NFS/backups/paperless-ngx";
        paths = [ config.services.paperless.dataDir ];
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
