{ self, inputs, ... }:
{
  flake.nixosConfigurations.dominaria = inputs.nixpkgs-unstable.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      inputs.agenix.nixosModules.default
      inputs.determinate.nixosModules.default
      inputs.hardware.nixosModules.common-cpu-amd
      inputs.hardware.nixosModules.common-cpu-amd-pstate
      inputs.hardware.nixosModules.common-gpu-amd
      inputs.hardware.nixosModules.common-pc-ssd
      inputs.nix-index-database.nixosModules.nix-index
      self.modules.nixos.dominariaConfiguration
      self.modules.nixos.dominariaHardwareConfiguration
    ];
  };
}
