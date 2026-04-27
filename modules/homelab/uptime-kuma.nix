{ ... }:
{
  flake.modules.nixos.homelab-uptime-kuma =
    { pkgs-unstable, ... }:

    {
      services.uptime-kuma = {
        enable = true;
        package = pkgs-unstable.uptime-kuma;
        settings = {
          HOST = "0.0.0.0";
        };
      };
    };
}
