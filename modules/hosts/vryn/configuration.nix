{ self, ... }:
{
  flake.modules.nixos.vrynConfiguration =
    { ... }:
    {
      imports = with self.modules.nixos; [
        homelab-matrix-turn
        homelab-nginx-vryn
        homelab-tailscale
        osBase
        ssh
        users-deploy
        vrynHardwareConfiguration
      ];
      networking = {
        hostName = "vryn";
        networkmanager.enable = true;
      };
      system.stateVersion = "25.05";
    };
}
