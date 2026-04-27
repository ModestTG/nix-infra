{ ... }:
{
  flake.modules.nixos.podman =
    { ... }:
    {
      virtualisation = {
        podman.enable = true;
        oci-containers.backend = "podman";
      };
    };
  flake.modules.nixos.docker =
    { ... }:
    {
      virtualisation.docker = {
        enable = true;
        daemon.settings.features.cdi = true;
        storageDriver = "overlay2";
      };
      users.users.eweishaar.extraGroups = [ "docker" ];
    };
}
