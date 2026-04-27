{ self, ... }:
{
  flake.modules.nixos.kaladeshConfiguration =
    {
      config,
      inputs,
      lib,
      pkgs,
      ...
    }:
    {
      imports = with self.modules.nixos; [
        docker
        homelab-audiobookshelf
        homelab-gatus
        homelab-home-assistant
        homelab-hytale-server
        homelab-immich
        homelab-jellyfin
        homelab-matrix-synapse
        homelab-mealie
        homelab-navidrome
        homelab-nginx-kaladesh
        homelab-node-red
        homelab-ollama-cuda
        homelab-paperless-ngx
        homelab-postgresql
        homelab-prowlarr
        homelab-radarr
        homelab-radicale
        homelab-recyclarr
        homelab-sabnzbd
        homelab-searxng
        homelab-sonarr
        homelab-stirling-pdf
        homelab-teamspeak6-server
        homelab-vaultwarden
        kaladeshDiskoConfiguration
        kaladeshHardwareConfiguration
        nfsAll
        nvidiaSupport
        osBase
        ssh
        users-deploy
      ];

      age.secrets.restic-password.file = builtins.toPath "${self.outPath}/secrets/restic-password.age";
      networking = {
        hostName = "kaladesh";
        firewall.enable = false;
        networkmanager.enable = true;
        enableIPv6 = false;
      };
      boot = {
        loader = {
          grub.enable = false;
          systemd-boot = {
            enable = true;
            configurationLimit = 20;
          };
          efi = {
            canTouchEfiVariables = true;
            efiSysMountPoint = "/boot";
          };
        };
      };
      users.users.eweishaar.extraGroups = [ "podman" ];
      virtualisation = {
        podman.enable = true;
        oci-containers.backend = "podman";
      };
      system.stateVersion = "25.05";
    };
}
