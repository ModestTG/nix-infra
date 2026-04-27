{ ... }:
{
  flake.modules.nixos.homelab-postgresql =
    { pkgs-unstable, ... }:
    {
      services.postgresql = {
        enable = true;
        package = pkgs-unstable.postgresql_17;
      };
    };
}
