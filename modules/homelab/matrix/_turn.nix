self: ewhs:
{ config, ... }:
let
  inherit (import ./_common.nix)
    domain
    matrixDomain
    turnDomain
    wellKnownLocations
    ;
in
{
  age.secrets.turn-secrets = {
    file = builtins.toPath "${self.outPath}/secrets/turn-secrets.age";
    owner = config.systemd.services.coturn.serviceConfig.User;
    group = config.systemd.services.coturn.serviceConfig.Group;
  };

  services.coturn = {
    enable = true;
    no-cli = true;
    no-tcp-relay = true;
    min-port = 49000;
    max-port = 50000;
    use-auth-secret = true;
    static-auth-secret-file = config.age.secrets.turn-secrets.path;
    realm = turnDomain;
    cert = "/var/lib/acme/${domain}/fullchain.pem";
    pkey = "/var/lib/acme/${domain}/key.pem";
    extraConfig = ''
      denied-peer-ip=10.0.0.0-10.255.255.255
      denied-peer-ip=192.168.0.0-192.168.255.255
      denied-peer-ip=172.16.0.0-172.31.255.255
      no-multicast-peers
      fingerprint
    '';
  };

  users.users.turnserver.extraGroups = [ config.security.acme.defaults.group ];
  security.acme.certs."${domain}".postRun = "systemctl restart coturn.service";

  services.nginx.virtualHosts = {
    "${domain}" = {
      forceSSL = true;
      useACMEHost = domain;
      locations = wellKnownLocations;
    };
    "${matrixDomain}" = {
      forceSSL = true;
      useACMEHost = domain;
      serverName = matrixDomain;
      listen = [
        {
          addr = "0.0.0.0";
          port = 443;
          ssl = true;
        }
        {
          addr = "[::]";
          port = 443;
          ssl = true;
        }
        {
          addr = "0.0.0.0";
          port = 8448;
          ssl = true;
        }
        {
          addr = "[::]";
          port = 8448;
          ssl = true;
        }
      ];
      locations."/" = {
        proxyPass = "http://${ewhs.const.kaladeshIP}:8008";
        proxyWebsockets = true;
        extraConfig = ''
          proxy_set_header X-Forwarded-For $remote_addr;
          proxy_set_header X-Forwarded-Proto $scheme;
          proxy_set_header Host $host;
          client_max_body_size 50M;
        '';
      };
    };
    "${turnDomain}" = {
      forceSSL = true;
      useACMEHost = domain;
    };
  };

  networking.firewall = {
    allowedTCPPorts = [
      3478
      5349
      8448
    ];
    allowedUDPPorts = [
      3478
      5349
    ];
    allowedUDPPortRanges = [
      {
        from = 49000;
        to = 50000;
      }
    ];
  };
}
