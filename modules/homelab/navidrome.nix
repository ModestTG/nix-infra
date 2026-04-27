{ self, ... }:
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
      services.nginx.virtualHosts."navidrome.ewhomelab.com" = {
        forceSSL = true;
        serverName = "navidrome.ewhomelab.com";
        useACMEHost = "ewhomelab.com";
        locations."/" = {
          proxyPass = "http://localhost:${toString config.services.navidrome.settings.Port}";
          proxyWebsockets = true;
        };
      };
      services.restic.backups.navidrome = {
        repository = "sftp:root@10.0.0.8:/mnt/AuxPool/K8S-NFS/backups/navidrome";
        paths = [ "/var/lib/navidrome" ];
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
