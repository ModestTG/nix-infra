{ ... }:
{
  flake.modules.nixos.homelab-prowlarr =
    { config, pkgs-unstable, ... }:
    {
      services.prowlarr = {
        enable = true;
        package = pkgs-unstable.prowlarr;
      };
      services.nginx.virtualHosts."prowlarr.ewhomelab.com" = {
        forceSSL = true;
        serverName = "prowlarr.ewhomelab.com";
        useACMEHost = "ewhomelab.com";
        locations."/" = {
          proxyPass = "http://localhost:${toString config.services.prowlarr.settings.server.port}";
          proxyWebsockets = true;
        };
      };
    };
}
