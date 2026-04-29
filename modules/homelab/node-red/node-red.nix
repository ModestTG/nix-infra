{ self, ewhs, ... }:

{
  flake.modules.nixos.homelab-node-red =
    { config, pkgs-unstable, ... }:
    {
      services.node-red = {
        enable = true;
        package = pkgs-unstable.node-red;
        withNpmAndGcc = true;
        configFile = ./settings.js;
      };
      services.nginx.virtualHosts."node-red.ewhomelab.com" = ewhs.lib.mkProxyVirtualHost {
        port = config.services.node-red.port;
        websockets = false;
      };
      services.restic.backups.node-red = {
        repository = "sftp:root@10.0.0.8:/mnt/AuxPool/K8S-NFS/backups/node-red";
        paths = [ config.services.node-red.userDir ];
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
