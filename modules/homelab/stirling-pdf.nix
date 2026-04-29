{ ewhs, ... }:
{
  flake.modules.nixos.homelab-stirling-pdf =
    { pkgs-unstable, ... }:
    {
      services.stirling-pdf = {
        enable = true;
        package = pkgs-unstable.stirling-pdf;
      };
      services.nginx.virtualHosts."pdf.ewhomelab.com" = ewhs.lib.mkProxyVirtualHost {
        port = 8080;
      };
    };
}
