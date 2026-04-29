{ self, ewhs, ... }:
{
  flake.modules.nixos.homelab-immich =
    { config, ... }:
    {
      system.activationScripts.immich-postgresql-dir =
        #bash
        ''
          if [ ! -d /var/lib/immich-postgresql ]; then
          	mkdir -p /var/lib/immich-postgresql
            chmod eweishaar:users /var/lib/immich-postgresql
          fi
        '';
      services.nginx.virtualHosts."photos.ewhomelab.com" = ewhs.lib.mkProxyVirtualHost {
        port = 2283;
        extraConfig = ''
          client_max_body_size 1000M;
        '';
      };
      services.restic.backups.immich-postgresql = {
        repository = "sftp:root@10.0.0.8:/mnt/AuxPool/K8S-NFS/backups/immich-postgresql";
        paths = [ "/var/lib/immich-postgresql" ];
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
