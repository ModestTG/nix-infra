{ self, ewhs, ... }:
{
  flake.modules.nixos = {
    homelab-nginx-kaladesh = import ./_kaladesh.nix self ewhs;
    homelab-nginx-vryn = import ./_vryn.nix self ewhs;
  };
}
