{ ewhs, ... }:
{
  flake.modules.nixos.homelab-prowlarr =
    { config, pkgs-unstable, ... }:
    {
      services.prowlarr = {
        enable = true;
        package = pkgs-unstable.prowlarr;
      };
      services.nginx.virtualHosts."prowlarr.ewhomelab.com" = ewhs.lib.mkProxyVirtualHost {
        port = config.services.prowlarr.settings.server.port;
      };
    };
}
