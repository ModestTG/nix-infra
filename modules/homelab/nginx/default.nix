{ self, ... }:
{
  flake.modules.nixos = {
    homelab-nginx-kaladesh = import ./_kaladesh.nix self;
    homelab-nginx-vryn = import ./_vryn.nix self;
  };
}
