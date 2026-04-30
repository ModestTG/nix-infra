{ self, ewhs, ... }:
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
      services.gatus.settings.endpoints = [
        (ewhs.lib.mkGatusEndpoint {
          name = "sabnzbd";
          url = "https://sabnzbd.ewhomelab.com";
        })
      ];
      services.nginx.virtualHosts."sabnzbd.ewhomelab.com" = ewhs.lib.mkProxyVirtualHost {
        port = 8081;
      };
      services.restic.backups.sabnzbd = ewhs.lib.mkResticBackup {
        name = "sabnzbd";
        paths = [ config.services.sabnzbd.configFile ];
        passwordFile = config.age.secrets.restic-password.path;
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
