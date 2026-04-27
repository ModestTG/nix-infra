{ self, ... }:

{
  flake.modules.nixos.nfsAll =
    { ... }:
    {
      imports = with self.modules.nixos; [
        nfsMedia
        nfsK8sNfs
        nfsPhotos
      ];
    };
  flake.modules.nixos.nfsBase =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [ nfs-utils ];
      services.rpcbind.enable = true;
      boot.supportedFilesystems = [ "nfs" ];
    };
  flake.modules.nixos.nfsMedia =
    { config, ... }:
    {
      imports = [ self.modules.nixos.nfsBase ];
      fileSystems."/mnt/plexpool" = {
        device = "${config.systemConstants.nasIP}:/mnt/PlexPool";
        fsType = "nfs";
        options = [
          "x-systemd.automount"
          "noauto"
        ];
      };
    };
  flake.modules.nixos.nfsK8sNfs =
    { config, ... }:
    {
      imports = [ self.modules.nixos.nfsBase ];
      fileSystems."/mnt/k8s-nfs" = {
        device = "${config.systemConstants.nasIP}:/mnt/AuxPool/K8S-NFS";
        fsType = "nfs";
        options = [
          "x-systemd.automount"
          "noauto"
        ];
      };
    };
  flake.modules.nixos.nfsPhotos =
    { config, ... }:
    {
      imports = [ self.modules.nixos.nfsBase ];
      fileSystems."/mnt/photos" = {
        device = "${config.systemConstants.nasIP}:/mnt/AuxPool/photos";
        fsType = "nfs";
        options = [
          "x-systemd.automount"
          "noauto"
        ];
      };
    };
}
