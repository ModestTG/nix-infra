{ self, ewhs, ... }:
{
  flake.modules.nixos.homelab-ntfy =
    { config, lib, pkgs-unstable, ... }:

    {
      age.secrets.ntfy-settings = {
        file = builtins.toPath "${self.outPath}/secrets/ntfy-settings.age";
        owner = config.services.ntfy-sh.user;
        group = config.services.ntfy-sh.group;
      };
      services.ntfy-sh = {
        enable = true;
        package = pkgs-unstable.ntfy-sh;
        environmentFile = config.age.secrets.ntfy-settings.path;
        settings = {
          base-url = "https://ntfy.ewhomelab.com";
          listen-http = ":8084";
          behind-proxy = true;
          auth-default-access = "deny-all";
          auth-file = "/var/lib/ntfy-sh/user.db";
          cache-file = "/var/lib/ntfy-sh/cache.db";
          cache-duration = "8760h"; # one year
        };
      };
      services.nginx.virtualHosts."ntfy.ewhomelab.com" =
        let
          ntfyPort = lib.strings.removePrefix ":" config.services.ntfy-sh.settings.listen-http;
        in
        ewhs.lib.mkProxyVirtualHost { port = ntfyPort; };
    };
}
