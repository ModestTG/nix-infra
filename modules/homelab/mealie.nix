{ self, ewhs, ... }:
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
      services.nginx.virtualHosts."recipes.ewhomelab.com" = ewhs.lib.mkProxyVirtualHost {
        port = config.services.mealie.port;
      };
      services.restic.backups.mealie = ewhs.lib.mkResticBackup {
        name = "mealie";
        paths = [ "/var/lib/mealie" ];
        passwordFile = config.age.secrets.restic-password.path;
      };
    };
}
