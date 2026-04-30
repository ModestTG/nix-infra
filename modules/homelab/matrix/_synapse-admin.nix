ewhs: { pkgs, ... }:
let
  inherit (import ./_common.nix)
    domain
    adminDomain
    ;
in
{
  services.gatus.settings.endpoints = [
    (ewhs.lib.mkGatusEndpoint {
      name = "matrix-synapse-admin";
      url = "https://${adminDomain}";
    })
  ];
  services.nginx.virtualHosts."${adminDomain}" = {
    useACMEHost = domain;
    forceSSL = true;
    root = "${pkgs.synapse-admin}";
    locations."/" = {
      tryFiles = "$uri $uri/ /index.html";
    };
  };
}
