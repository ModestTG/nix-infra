{ inputs, ... }:
{
  flake.modules.nixos.deployNode =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        inputs.colmena.packages.${pkgs.stdenv.hostPlatform.system}.colmena
        inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.agenix
        pkgs.restic-browser
      ];
      nix.settings = {
        substituters = [ "https://colmena.cachix.org" ];
        trusted-public-keys = [ "colmena.cachix.org-1:7BzpDnjjH8ki2CT3f6GdOk7QAzPOl+1t3LvTLXqYcSg=" ];
        trusted-users = [ "eweishaar" ];
      };
    };
}
