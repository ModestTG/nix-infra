{ self, ... }:
{
  flake.modules.nixos.homelab-sabnzbd =
    { config, pkgs-unstable, ... }:
    {
      services.sabnzbd = {
        enable = true;
        package = pkgs-unstable.sabnzbd;
        user = "eweishaar";
        group = "users";
      };
      services.nginx.virtualHosts."sabnzbd.ewhomelab.com" = {
        forceSSL = true;
        serverName = "sabnzbd.ewhomelab.com";
        useACMEHost = "ewhomelab.com";
        locations."/" = {
          proxyPass = "http://localhost:8081";
          proxyWebsockets = true;
        };
      };
      services.restic.backups.sabnzbd = {
        repository = "sftp:root@10.0.0.8:/mnt/AuxPool/K8S-NFS/backups/sabnzbd";
        paths = [ config.services.sabnzbd.configFile ];
        passwordFile = config.age.secrets.restic-password.path;
        initialize = true;
        pruneOpts = [
          "--keep-daily 14"
          "--keep-monthly 6"
          "--keep-yearly 1"
        ];
      };
      system.activationScripts.media-folder =
        #bash
        ''
          if [ ! -d /var/lib/media ]; then
          	mkdir -p /var/lib/media/{in,out,tmp};
          	chown -R eweishaar:users /var/lib/media;
          fi
        '';
    };
}
