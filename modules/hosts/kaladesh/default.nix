{ self, inputs, ... }:
{
  flake.colmena.kaladesh = {
    deployment = {
      targetHost = "kaladesh";
      targetUser = "deploy";
      tags = [ "server" ];
      buildOnTarget = true;
    };
    imports = [
      inputs.agenix.nixosModules.default
      inputs.hardware.nixosModules.common-cpu-intel
      inputs.hardware.nixosModules.common-pc-ssd
      self.modules.nixos.kaladeshConfiguration
    ];
  };
}
