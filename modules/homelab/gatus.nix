{ self, ewhs, ... }:
{
  flake.modules.nixos.homelab-gatus =
    { config, pkgs-unstable, ... }:

    {
      age.secrets.gatus-matrix-token.file = builtins.toPath "${self.outPath}/secrets/gatus-matrix-token.age";
      services.gatus = {
        enable = true;
        package = pkgs-unstable.gatus;
        environmentFile = config.age.secrets.gatus-matrix-token.path;
        settings = {
          web.port = 8083;
          alerting.matrix = {
            server-url = "https://matrix.ewhomelab.com";
            access-token = "$MATRIX_ACCESS_TOKEN";
            internal-room-id = "!VGDtzgOQgrHpqqDFfE:ewhomelab.com";
          };
        };
      };

      services.nginx.virtualHosts."gatus.ewhomelab.com" = ewhs.lib.mkProxyVirtualHost {
        port = config.services.gatus.settings.web.port;
      };
    };
}
