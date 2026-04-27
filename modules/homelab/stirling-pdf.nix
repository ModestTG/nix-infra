{ ... }:
{
  flake.modules.nixos.homelab-stirling-pdf =
    { pkgs-unstable, ... }:
    {
      services.stirling-pdf = {
        enable = true;
        package = pkgs-unstable.stirling-pdf;
      };
      services.nginx.virtualHosts."pdf.ewhomelab.com" = {
        forceSSL = true;
        serverName = "pdf.ewhomelab.com";
        useACMEHost = "ewhomelab.com";
        locations."/" = {
          proxyPass = "http://localhost:8080";
          proxyWebsockets = true;
        };
      };
    };
}
