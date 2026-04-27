{ ... }:
{
  flake.modules.homeManager.dunst =
    { ... }:
    {
      services.dunst.enable = true;
    };
}
