{ ... }:
{
  flake.modules.nixos.homelab-prowlarr =
    { config, homeLab, pkgs-unstable, ... }:
    {
      services.prowlarr = {
        enable = true;
        package = pkgs-unstable.prowlarr;
      };
      services.nginx.virtualHosts."prowlarr.ewhomelab.com" = homeLab.mkProxyVirtualHost {
        port = config.services.prowlarr.settings.server.port;
      };
    };
}
