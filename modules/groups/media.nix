{ ... }:
{
  flake.modules.nixos.groups-media =
    { ... }:
    {
      users.groups.media = {
        gid = 1100;
        name = "media";
      };
    };
}
