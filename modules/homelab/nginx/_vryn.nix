self:
{ config, homeLab, pkgs-unstable, ... }:
{
  imports = [
    (import ./_base.nix self {
      inherit config pkgs-unstable;
      dnsPropagationCheck = false;
      extraLegoFlags = [ "--dns.propagation-rns" ];
    })
  ];
  services.nginx.virtualHosts = {
    "photos.ewhomelab.com" = homeLab.mkProxyVirtualHost {
      host = "10.0.20.22";
      port = 2283;
      extraConfig = "client_max_body_size 1000M;";
    };
    "jellyfin.ewhomelab.com" = homeLab.mkProxyVirtualHost {
      host = "10.0.20.22";
      port = 8096;
    };
    "radicale.ewhomelab.com" = homeLab.mkProxyVirtualHost {
      host = "10.0.20.22";
      port = 5232;
    };
  };
}
