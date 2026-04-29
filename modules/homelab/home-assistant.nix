{ self, ewhs, ... }:
{
  flake.modules.nixos.homelab-home-assistant =
    { config, ... }:
    {
      virtualisation.oci-containers.containers.home-assistant = {
        hostname = "home-assistant";
        image = "ghcr.io/home-operations/home-assistant:2026.3.4";
        user = "1000:100";
        volumes = [
          "/var/lib/home-assistant:/config"
        ];
        extraOptions = [ "--network=host" ];
      };
      services.nginx.virtualHosts."hass.ewhomelab.com" = ewhs.lib.mkProxyVirtualHost {
        port = 8123;
      };
      services.restic.backups.home-assistant = {
        repository = "sftp:root@10.0.0.8:/mnt/AuxPool/K8S-NFS/backups/home-assistant";
        paths = [ "/var/lib/home-assistant" ];
        passwordFile = config.age.secrets.restic-password.path;
        initialize = true;
        pruneOpts = [
          "--keep-daily 14"
          "--keep-monthly 6"
          "--keep-yearly 1"
        ];
      };
      system.activationScripts.home-assistant-dir =
        #bash
        ''
          if [ ! -d /var/lib/home-assistant ]; then
          	mkdir -p /var/lib/home-assistant;
          	chown -R eweishaar:users /var/lib/home-assistant;
          fi
        '';
    };
}
