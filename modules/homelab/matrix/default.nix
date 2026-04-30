{ self, ewhs, ... }:
{
  flake.modules.nixos = {
    homelab-matrix-synapse = import ./_synapse.nix self;
    homelab-matrix-synapse-admin = import ./_synapse-admin.nix;
    homelab-matrix-turn = import ./_turn.nix self ewhs;
  };
}
