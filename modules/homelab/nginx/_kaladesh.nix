self:
{ config, homeLab, pkgs-unstable, ... }:
{
  imports = [ (import ./_base.nix self { inherit config pkgs-unstable; }) ];
  services.nginx.virtualHosts = {
    "_" = {
      default = true;
      forceSSL = true;
      useACMEHost = "ewhomelab.com";
      locations."/" = {
        return = 404;
      };
    };
    "unifi.ewhomelab.com" = homeLab.mkProxyVirtualHost {
      scheme = "https";
      host = "10.0.0.19";
      port = 443;
    };
  };
}
