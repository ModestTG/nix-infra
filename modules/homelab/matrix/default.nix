{ self, ewhs, ... }:
{
  flake.modules.nixos = {
    homelab-matrix-synapse = import ./_synapse.nix self ewhs;
    homelab-matrix-synapse-admin = import ./_synapse-admin.nix ewhs;
    homelab-matrix-turn = import ./_turn.nix self ewhs;
  };
}
