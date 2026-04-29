self: ewhs:
{ config, pkgs-unstable, ... }:
{
  imports = [
    (import ./_base.nix self {
      inherit config pkgs-unstable;
      dnsPropagationCheck = false;
      extraLegoFlags = [ "--dns.propagation-rns" ];
    })
  ];
  services.nginx.virtualHosts = {
    "photos.ewhomelab.com" = ewhs.lib.mkProxyVirtualHost {
      host = ewhs.const.kaladeshIP;
      port = 2283;
      extraConfig = "client_max_body_size 1000M;";
    };
    "jellyfin.ewhomelab.com" = ewhs.lib.mkProxyVirtualHost {
      host = ewhs.const.kaladeshIP;
      port = 8096;
    };
    "radicale.ewhomelab.com" = ewhs.lib.mkProxyVirtualHost {
      host = ewhs.const.kaladeshIP;
      port = 5232;
    };
  };
}
