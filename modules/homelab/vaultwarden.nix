{ self, ... }:
{
  flake.modules.nixos.homelab-vaultwarden =
    { config, homeLab, pkgs-unstable, ... }:

    {
      age.secrets.vaultwarden-admin-token = {
        file = builtins.toPath "${self.outPath}/secrets/vaultwarden-admin-token.age";
        owner = config.systemd.services.vaultwarden.serviceConfig.User;
        group = config.systemd.services.vaultwarden.serviceConfig.Group;
      };
      services.vaultwarden = {
        enable = true;
        package = pkgs-unstable.vaultwarden;
        webVaultPackage = pkgs-unstable.vaultwarden.webvault;
        config = {
          ROCKET_ADDRESS = "0.0.0.0";
          ROCKET_PORT = 8222;
          DOMAIN = "https://vault.ewhomelab.com";
          WEBSOCKET_ENABLED = true;
          WEBSOCKET_ADDRESS = "0.0.0.0";
          WEBSOCKET_PORT = 3012;
          SHOW_PASSWORD_HINT = false;
        };
        environmentFile = config.age.secrets.vaultwarden-admin-token.path;
      };
      services.nginx.virtualHosts."vault.ewhomelab.com" = homeLab.mkProxyVirtualHost {
        port = config.services.vaultwarden.config.ROCKET_PORT;
      };
    };
}
