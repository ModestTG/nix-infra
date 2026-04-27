{ self, inputs, ... }:
{
  flake.colmena.vryn = {
    deployment = {
      targetHost = "vryn";
      targetUser = "deploy";
      tags = [ "vps" ];
      buildOnTarget = true;
    };
    imports = [
      inputs.agenix.nixosModules.default
      self.modules.nixos.vrynConfiguration
    ];
  };
}
