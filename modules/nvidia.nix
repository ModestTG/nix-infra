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
      nix.settings = {
        substituters = [ "https://cache.nixos-cuda.org" ];
        trusted-public-keys = [ "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M=" ];
      };
      nixpkgs.config.cudaSupport = true;
      services.xserver.videoDrivers = [ "nvidia" ];
    };
}
