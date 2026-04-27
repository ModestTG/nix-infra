{ ... }:
{
  flake.modules.nixos.printing =
    { ... }:
    {
      services.printing.enable = true;
    };
  flake.modules.nixos.scanning =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [ epsonscan2 ];
      hardware.sane = {
        enable = true;
        extraBackends = [ pkgs.epsonscan2 ];
      };
    };
}
