{ inputs, ... }:
{
  flake.modules.nixos.gaming =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        prismlauncher
        r2modman
        xmage
        (inputs.hytale-launcher.packages.${pkgs.stdenv.hostPlatform.system}.default)
      ];
      programs.steam = {
        enable = true;
        extraPackages = with pkgs; [
          gamescope
        ];
      };
      programs.gamemode.enable = true;
    };
}
