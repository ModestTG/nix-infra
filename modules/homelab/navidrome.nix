{ self, ewhs, ... }:
{
  flake.modules.nixos.homelab-navidrome =
    {
      config,
      lib,
      pkgs-unstable,
      ...
    }:

    {
      services.navidrome = {
        enable = true;
        package = pkgs-unstable.navidrome;
        settings = {
          Address = "0.0.0.0";
          MusicFolder = "/mnt/plexpool/music";
          BaseUrl = "https://navidrome.ewhomelab.com";
          CoverArtPriority = "embedded";
          Scanner.PurgeMissing = "full";
        };
      };
      users.users.navidrome.extraGroups = [ "users" ];
      systemd.services.navidrome.serviceConfig.MemoryDenyWriteExecute = lib.mkForce false;
      services.nginx.virtualHosts."navidrome.ewhomelab.com" = ewhs.lib.mkProxyVirtualHost {
        port = config.services.navidrome.settings.Port;
      };
      services.restic.backups.navidrome = ewhs.lib.mkResticBackup {
        name = "navidrome";
        paths = [ "/var/lib/navidrome" ];
        passwordFile = config.age.secrets.restic-password.path;
      };
    };
}
