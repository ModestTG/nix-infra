{ ewhs, ... }:

{
  flake.modules.nixos.homelab-audiobookshelf =
    { config, pkgs-unstable, ... }:
    {
      services.audiobookshelf = {
        enable = true;
        package = pkgs-unstable.audiobookshelf;
        user = "eweishaar";
        group = "users";
        port = 8003;
        host = "0.0.0.0";
      };
      services.nginx.virtualHosts."audiobookshelf.ewhomelab.com" = ewhs.lib.mkProxyVirtualHost {
        port = config.services.audiobookshelf.port;
        extraConfig = ''
          client_max_body_size 5000M;
        '';
      };
      services.restic.backups.audiobookshelf = ewhs.lib.mkResticBackup {
        name = "audiobookshelf";
        paths = [ "/var/lib/${config.services.audiobookshelf.dataDir}" ];
        passwordFile = config.age.secrets.restic-password.path;
      };
      services.gatus.settings.endpoints = [
        (ewhs.lib.mkGatusEndpoint {
          name = "audiobookshelf";
          url = "https://audiobookshelf.ewhomelab.com";
        })
      ];
    };
}
