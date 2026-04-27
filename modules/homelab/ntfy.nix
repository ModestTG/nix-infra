{ self, ... }:
{
  flake.modules.nixos.homelab-ntfy =
    { config, pkgs-unstable, ... }:

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
      services.nginx.virtualHosts."ntfy.ewhomelab.com" = {
        forceSSL = true;
        serverName = "ntfy.ewhomelab.com";
        useACMEHost = "ewhomelab.com";
        locations."/" = {
          proxyPass = "http://localhost${config.services.ntfy-sh.settings.listen-http}";
          proxyWebsockets = true;
        };
      };
    };
}
