{ ... }:
{
  flake.modules.generic.homeLab =
    { ... }:
    {
      _module.args.homeLab = import ./lib.nix;
    };
}
