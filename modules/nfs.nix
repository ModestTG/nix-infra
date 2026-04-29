{ ewhs, self, ... }:

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
    { ... }:
    {
      imports = [ self.modules.nixos.nfsBase ];
      fileSystems."/mnt/plexpool" = {
        device = "${ewhs.const.nasIP}:/mnt/PlexPool";
        fsType = "nfs";
        options = [
          "x-systemd.automount"
          "noauto"
        ];
      };
    };
  flake.modules.nixos.nfsK8sNfs =
    { ... }:
    {
      imports = [ self.modules.nixos.nfsBase ];
      fileSystems."/mnt/k8s-nfs" = {
        device = "${ewhs.const.nasIP}:/mnt/AuxPool/K8S-NFS";
        fsType = "nfs";
        options = [
          "x-systemd.automount"
          "noauto"
        ];
      };
    };
  flake.modules.nixos.nfsPhotos =
    { ... }:
    {
      imports = [ self.modules.nixos.nfsBase ];
      fileSystems."/mnt/photos" = {
        device = "${ewhs.const.nasIP}:/mnt/AuxPool/photos";
        fsType = "nfs";
        options = [
          "x-systemd.automount"
          "noauto"
        ];
      };
    };
}
