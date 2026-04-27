{ inputs, ... }:
{
  imports = with inputs; [
    flake-parts.flakeModules.modules
    home-manager.flakeModules.home-manager
  ];
  systems = [ "x86_64-linux" ];
}
