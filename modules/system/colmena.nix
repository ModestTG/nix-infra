{
  self,
  inputs,
  lib,
  ...
}:
let
  system = "x86_64-linux";
  pkgs-unstable = import inputs.nixpkgs-unstable {
    inherit system;
    config.allowUnfree = true;
  };
in
{
  # needed so `flake.colmena` can be auto merged across different files
  options.flake.colmena = lib.mkOption {
    type = lib.types.attrsOf lib.types.raw;
    default = { };
  };
  config = {
    flake.colmenaHive = inputs.colmena.lib.makeHive self.colmena;
    flake.colmena.meta = {
      nixpkgs = import inputs.nixpkgs { inherit system; };
      specialArgs = { inherit inputs pkgs-unstable; };
    };
    flake.checks.x86_64-linux = {
      kaladesh = self.colmenaHive.nodes.kaladesh.config.system.build.toplevel;
      vryn = self.colmenaHive.nodes.vryn.config.system.build.toplevel;
    };
  };
}
