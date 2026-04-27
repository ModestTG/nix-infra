self:
{ config, pkgs-unstable, ... }:
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
    "unifi.ewhomelab.com" = {
      forceSSL = true;
      serverName = "unifi.ewhomelab.com";
      useACMEHost = "ewhomelab.com";
      locations."/" = {
        proxyPass = "https://10.0.0.19";
        proxyWebsockets = true;
      };
    };
  };
}
