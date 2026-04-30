{ self, ewhs, ... }:
{
  flake.modules.nixos.homelab-traefik =
    { config, pkgs-unstable, ... }:
    {
      services.gatus.settings.endpoints = [
        (ewhs.lib.mkGatusEndpoint {
          name = "traefik";
          url = "https://traefik-int.ewhomelab.com";
        })
      ];
      services.traefik = {
        enable = true;
        package = pkgs-unstable.traefik;
        environmentFiles = [ config.age.secrets.cf-dns-api-token.path ];
        staticConfigOptions = {
          global = {
            checkNewVersion = false;
            sendAnonymousUsage = false;
          };
          entryPoints = {
            web = {
              address = ":80";
              http.redirections.entrypoint = {
                to = "websecure";
                scheme = "https";
              };
            };
            websecure = {
              address = ":443";
              http.tls = {
                certResolver = "letsencrypt";
                domains = [
                  {
                    main = "ewhomelab.com";
                    sans = "*.ewhomelab.com";
                  }
                ];
              };
            };
          };
          log = {
            level = "INFO";
            format = "json";
          };
          certificatesResolvers.letsencrypt.acme = {
            email = "elliotweishaar27@gmail.com";
            storage = "${config.services.traefik.dataDir}/acme.json";
            dnsChallenge = {
              provider = "cloudflare";
              resolvers = [
                "1.1.1.1:53"
                "1.0.0.1:53"
              ];
              propagation.delayBeforeChecks = 60;
            };
          };
          api.dashboard = true;
        };
        dynamicConfigOptions.http = {
          routers = {
            api = {
              rule = "Host(`traefik-int.ewhomelab.com`)";
              service = "api@internal";
              entrypoints = [ "websecure" ];
              tls.certResolver = "letsencrypt";
            };
          };
        };
      };
    };
}
