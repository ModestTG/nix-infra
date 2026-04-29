{ self, ... }:

{
  flake.modules.nixos.homelab-audiobookshelf =
    { config, homeLab, pkgs-unstable, ... }:
    {
      services.audiobookshelf = {
        enable = true;
        package = pkgs-unstable.audiobookshelf;
        user = "eweishaar";
        group = "users";
        port = 8003;
        host = "0.0.0.0";
      };
      services.nginx.virtualHosts."audiobookshelf.ewhomelab.com" = homeLab.mkProxyVirtualHost {
        port = config.services.audiobookshelf.port;
        extraConfig = ''
          client_max_body_size 5000M;
        '';
      };
      services.restic.backups.audiobookshelf = {
        repository = "sftp:root@10.0.0.8:/mnt/AuxPool/K8S-NFS/backups/audiobookshelf";
        paths = [ "/var/lib/${config.services.audiobookshelf.dataDir}" ];
        passwordFile = config.age.secrets.restic-password.path;
        initialize = true;
        pruneOpts = [
          "--keep-daily 14"
          "--keep-monthly 6"
          "--keep-yearly 1"
        ];
      };
      services.gatus.settings.endpoints = [
        {
          name = "audiobookshelf";
          url = "https://audiobookshelf.ewhomelab.com";
          interval = "1m";
          conditions = [
            "[STATUS] == 200"
            "[RESPONSE_TIME] < 300"
          ];
        }
      ];
    };
}
