{ ... }:
{
  flake.modules.nixos.homelab-hytale-server =
    { ... }:
    {
      virtualisation.oci-containers.containers.hytale-server = {
        hostname = "hytale-server";
        image = "ghcr.io/slowline/hytale-docker:1.0.13";
        extraOptions = [
          "--tty"
          "--interactive"
        ];
        ports = [
          "5520:5520/udp"
        ];
        volumes = [
          "/var/lib/hytale:/hytale" # Persistent server data
          "/etc/machine-id:/etc/machine-id:ro" # encrypted auth persistence (requires machine-id)
        ];
        environment = {
          # Server / networking
          HYTALE_PORT = "5520";
          BIND_ADDR = "0.0.0.0";

          # Assets / auth
          ASSETS_PATH = "/hytale/Assets.zip";
          AUTH_MODE = "authenticated";

          # Updates
          ENABLE_AUTO_UPDATE = "true";
          SKIP_DELETE_ON_FORBIDDEN = "false";

          # AOT cache
          USE_AOT_CACHE = "true";

          # Flags
          ACCEPT_EARLY_PLUGINS = "false";
          ALLOW_OP = "false";
          DISABLE_SENTRY = "false";

          # Backups
          BACKUP_ENABLED = "true";
          BACKUP_DIR = "/hytale/backups";
          BACKUP_FREQUENCY = "30";

          # Java memory
          JAVA_XMS = "4G";
          JAVA_XMX = "4G";
          # JAVA_CMD_ADDITIONAL_OPTS = "";

          # Additional server options
          # HYTALE_ADDITIONAL_OPTS = "";

          # Server Provider Authentication (optional)
          # SESSION_TOKEN = "";
          # IDENTITY_TOKEN = "";
          # OWNER_UUID = "";
        };
      };
      system.activationScripts.hytale-server-dir =
        #bash
        ''
          if [ ! -d /var/lib/hytale ]; then
          	mkdir -p /var/lib/hytale;
          	chown -R 1000:1000 /var/lib/hytale;
          fi
        '';
    };
}
