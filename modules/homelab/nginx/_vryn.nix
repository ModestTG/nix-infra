self:
{ config, pkgs-unstable, ... }:
{
  imports = [
    (import ./_base.nix self {
      inherit config pkgs-unstable;
      dnsPropagationCheck = false;
      extraLegoFlags = [ "--dns.propagation-rns" ];
    })
  ];
  services.nginx.virtualHosts =
    let
      forceSSL = true;
      useACMEHost = "ewhomelab.com";
    in
    {
      "photos.ewhomelab.com" = {
        inherit forceSSL useACMEHost;
        serverName = "photos.ewhomelab.com";
        locations."/" = {
          proxyPass = "http://10.0.20.22:2283";
          proxyWebsockets = true;
          extraConfig = "client_max_body_size 1000M;";
        };
      };
      "jellyfin.ewhomelab.com" = {
        inherit forceSSL useACMEHost;
        serverName = "jellyfin.ewhomelab.com";
        locations."/" = {
          proxyPass = "http://10.0.20.22:8096";
          proxyWebsockets = true;
        };
      };
      "radicale.ewhomelab.com" = {
        inherit forceSSL useACMEHost;
        serverName = "radicale.ewhomelab.com";
        locations."/" = {
          proxyPass = "http://10.0.20.22:5232";
          proxyWebsockets = true;
        };
      };
    };
}
