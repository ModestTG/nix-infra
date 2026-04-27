{ ... }:
{
  flake.modules.nixos.ntp =
    { ... }:
    {
      services.ntp.enable = true;
      networking.timeServers = [ "10.0.0.1" ];
    };
}
