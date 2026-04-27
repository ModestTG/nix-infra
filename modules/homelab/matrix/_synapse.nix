self:
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
  age.secrets.matrix-synapse-secrets = {
    file = builtins.toPath "${self.outPath}/secrets/matrix-synapse-secrets.age";
    owner = config.systemd.services.matrix-synapse.serviceConfig.User;
    group = config.systemd.services.matrix-synapse.serviceConfig.Group;
  };

  services.matrix-synapse = {
    enable = true;
    extraConfigFiles = [ config.age.secrets.matrix-synapse-secrets.path ];
    settings = {
      server_name = domain;
      public_baseurl = "https://${matrixDomain}";
      listeners = [
        {
          port = 8008;
          bind_addresses = [ "0.0.0.0" ];
          type = "http";
          tls = false;
          x_forwarded = true;
          resources = [
            {
              names = [
                "client"
                "federation"
              ];
              compress = true;
            }
          ];
        }
      ];
      database = {
        name = "psycopg2";
        args = {
          user = "matrix-synapse";
          password = "synapse_db_password";
          database = "matrix-synapse";
          host = "/run/postgresql";
          cp_min = 5;
          cp_max = 10;
        };
      };
      enable_registration = false;
      turn_uris = [
        "turn:${turnDomain}:3478?transport=udp"
        "turn:${turnDomain}:3478?transport=tcp"
        "turns:${turnDomain}:5349?transport=udp"
        "turns:${turnDomain}:5349?transport=tcp"
      ];
      turn_user_lifetime = "1h";
      max_upload_size = "50M";
      url_preview_enabled = true;
      enable_metrics = false;
      url_preview_ip_range_blacklist = [
        "127.0.0.0/8"
        "10.0.0.0/8"
        "172.16.0.0/12"
        "192.168.0.0/16"
        "100.64.0.0/10"
        "192.0.0.0/24"
        "169.254.0.0/16"
        "198.18.0.0/15"
        "::1/128"
        "fe80::/10"
        "fc00::/7"
      ];
      trusted_key_servers = [ { server_name = "matrix.org"; } ];
    };
  };

  systemd.services.matrix-synapse = {
    wants = [ "postgresql.service" ];
    after = [ "postgresql.service" ];
  };

  services.postgresql = {
    ensureUsers = [
      {
        name = "matrix-synapse";
        ensureDBOwnership = true;
      }
    ];
    ensureDatabases = [ "matrix-synapse" ];
  };

  services.nginx.virtualHosts = {
    "${domain}" = {
      useACMEHost = domain;
      forceSSL = true;
      locations = wellKnownLocations;
    };
    "${matrixDomain}" = {
      useACMEHost = domain;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:8008";
        proxyWebsockets = true;
        extraConfig = ''
          proxy_set_header X-Forwarded-For $remote_addr;
          proxy_set_header X-Forwarded-Proto $scheme;
          proxy_set_header Host $host;
          client_max_body_size 50M;
        '';
      };
    };
  };
}
