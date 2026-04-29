{ ... }:
{
  flake.modules.nixos.homelab-stirling-pdf =
    { homeLab, pkgs-unstable, ... }:
    {
      services.stirling-pdf = {
        enable = true;
        package = pkgs-unstable.stirling-pdf;
      };
      services.nginx.virtualHosts."pdf.ewhomelab.com" = homeLab.mkProxyVirtualHost {
        port = 8080;
      };
    };
}
