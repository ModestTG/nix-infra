{ self, ... }:
{
  flake.modules.nixos.homelab-gatus =
    { config, homeLab, pkgs-unstable, ... }:

    {
      age.secrets.gatus-ntfy-token.file = builtins.toPath "${self.outPath}/secrets/gatus-ntfy-token.age";
      services.gatus = {
        enable = true;
        package = pkgs-unstable.gatus;
        environmentFile = config.age.secrets.gatus-ntfy-token.path;
        settings = {
          web.port = 8083;
        };
      };
      services.nginx.virtualHosts."gatus.ewhomelab.com" = homeLab.mkProxyVirtualHost {
        port = config.services.gatus.settings.web.port;
      };
    };
}
