{ ... }:
{
  flake.modules.homeManager.starship =
    { lib, pkgs, ... }:
    {
      programs.starship = {
        enable = true;
        settings = lib.mkMerge [
          (fromTOML (builtins.readFile "${pkgs.starship}/share/starship/presets/nerd-font-symbols.toml"))
        ];
      };
    };
}
