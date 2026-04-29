{ self, ewhs, ... }:
{
  flake.modules.nixos.homelab-jellyfin =
    { config, pkgs-unstable, ... }:
    {
      services.jellyfin = {
        enable = true;
        package = pkgs-unstable.jellyfin;
        user = "eweishaar";
        group = "users";
      };
      services.nginx.virtualHosts."jellyfin.ewhomelab.com" = ewhs.lib.mkProxyVirtualHost {
        port = 8096;
      };
      services.restic.backups.jellyfin = ewhs.lib.mkResticBackup {
        name = "jellyfin";
        paths = [ config.services.jellyfin.dataDir ];
        passwordFile = config.age.secrets.restic-password.path;
      };
    };
}
