{ self, ewhs, ... }:
{
  flake.modules.nixos.homelab-searxng =
    { config, pkgs-unstable, ... }:
    {
      age.secrets.searxng-secret-key.file = builtins.toPath "${self.outPath}/secrets/searxng-secret-key.age";
      services.searx = {
        enable = true;
        package = pkgs-unstable.searxng;
        redisCreateLocally = true;
        environmentFile = config.age.secrets.searxng-secret-key.path;
        settings = {
          enabled_plugins = [
            "Basic Calculator"
            "Hash plugin"
            "Hostnames plugin"
            "Open Access DOI rewrite"
            "Self Informations"
            "Tracker URL remover"
            "Unit converter plugin"
          ];
          general = {
            instance_name = "EWHS Search";
          };
          hostnames = {
            high_priority = [
              "(.*)\\/blog\\/(.*)"
              "(.*\\.)?wikipedia.org$"
              "(.*\\.)?github.com$"
              "(.*\\.)?reddit.com$"
              "(.*\\.)?linuxserver.io$"
              "(.*\\.)?docker.com$"
              "(.*\\.)?archlinux.org$"
              "(.*\\.)?stackoverflow.com$"
              "(.*\\.)?askubuntu.com$"
              "(.*\\.)?superuser.com$"
            ];
          };
          search = {
            autocomplete = "duckduckgo";
            default_lang = "en-US";
            formats = [
              "html"
              "json"
            ];
          };
          server = {
            bind_address = "0.0.0.0";
            base_url = "https://search.ewhomelab.com";
            port = 8082;
            image_proxy = true;
            method = "GET";
          };
          ui = {
            default_theme = "simple";
            infinite_scroll = true;
            results_on_new_tab = false;
            static_use_hash = true;
            theme_args = {
              simple_style = "dark";
            };
          };
          use_default_settings = true;
        };
        limiterSettings = {
          botdetection = {
            ip_limit = {
              filter_link_local = true;
              link_token = false;
            };
            ip_lists = {
              block_ip = [ ];
              pass_ip = [ "10.0.0.0/24" ];
              pass_searxng_org = false;
            };
          };
          real_ip = {
            ipv4_prefix = 32;
            ipv6_prefix = 48;
            x_for = 1;
          };
        };
      };
      services.gatus.settings.endpoints = [
        (ewhs.lib.mkGatusEndpoint {
          name = "searxng";
          url = "https://search.ewhomelab.com";
        })
      ];
      services.nginx.virtualHosts."search.ewhomelab.com" = ewhs.lib.mkProxyVirtualHost {
        port = config.services.searx.settings.server.port;
      };
    };
}
