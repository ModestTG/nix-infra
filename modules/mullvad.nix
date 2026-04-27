{ ... }:
{
  flake.modules.nixos.mullvadVpn =
    { pkgs, ... }:
    {
      services.mullvad-vpn = {
        enable = true;
        package = pkgs.mullvad-vpn;
      };
    };
}
