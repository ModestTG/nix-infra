{ ... }:
{
  flake.modules.nixos.cosmicWm =
    { ... }:
    {
      services.desktopManager.cosmic.enable = true;
    };
}
