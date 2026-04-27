{ inputs, ... }:
{
  flake.modules.nixos.nvidiaSupport =
    { config, pkgs, ... }:
    {
      imports = [ inputs.hardware.nixosModules.common-gpu-nvidia-nonprime ];
      hardware = {
        nvidia = {
          open = true;
          package = config.boot.kernelPackages.nvidiaPackages.stable;
          nvidiaPersistenced = true;
          modesetting.enable = true;
        };
        graphics = {
          enable = true;
          extraPackages = with pkgs; [
            cudatoolkit
          ];
        };
        nvidia-container-toolkit.enable = true;
      };
      nixpkgs.config.cudaSupport = true;
      services.xserver.videoDrivers = [ "nvidia" ];
    };
}
