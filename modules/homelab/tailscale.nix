{ self, ... }:
{
  flake.modules.nixos.homelab-tailscale =
    { config, pkgs-unstable, ... }:
    {
      age.secrets.tailscale-preauth-key.file = builtins.toPath "${self.outPath}/secrets/tailscale-preauth-key.age";
      services.tailscale = {
        enable = true;
        package = pkgs-unstable.tailscale;
        useRoutingFeatures = "both";
        authKeyFile = config.age.secrets.tailscale-preauth-key.path;
        extraUpFlags = [ "--accept-routes" ];
        extraSetFlags = [ "--accept-routes" ];
        openFirewall = true;
      };
    };
}
