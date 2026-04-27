{ ... }:
{
  flake.modules.nixos.doas =
    { ... }:
    {
      security = {
        doas.enable = true;
        sudo.enable = false;
      };
    };
}
