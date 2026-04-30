{ pkgs, ... }:
let
  inherit (import ./_common.nix)
    domain
    adminDomain
    ;
in
{
  services.nginx.virtualHosts."${adminDomain}" = {
    useACMEHost = domain;
    forceSSL = true;
    root = "${pkgs.synapse-admin}";
    locations."/" = {
      tryFiles = "$uri $uri/ /index.html";
    };
  };
}
