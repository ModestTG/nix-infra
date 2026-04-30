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
      services.gatus.settings.endpoints = [
        (ewhs.lib.mkGatusEndpoint {
          name = "node-red";
          url = "https://node-red.ewhomelab.com";
        })
      ];
      services.nginx.virtualHosts."node-red.ewhomelab.com" = ewhs.lib.mkProxyVirtualHost {
        port = config.services.node-red.port;
        websockets = false;
      };
      services.restic.backups.node-red = ewhs.lib.mkResticBackup {
        name = "node-red";
        paths = [ config.services.node-red.userDir ];
        passwordFile = config.age.secrets.restic-password.path;
      };
    };
}
