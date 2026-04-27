{ self, ... }:
{
  flake.modules.nixos.dominariaConfiguration =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      imports = with self.modules.nixos; [
        deployNode
        doas
        groups-media
        mullvadVpn
        nfsAll
        osBase
        printing
        scanning
        desktopAlpha
      ];
      home-manager.users.eweishaar.xdg.mimeApps = {
        enable = true;
        defaultApplications = {
          "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" = "calc.desktop";
          "inode/directory" = "thunar.desktop"; # File Browser
        };
      };
      age.secrets.eweishaar-ssh-private-key = {
        file = builtins.toPath "${self.outPath}/secrets/eweishaar-ssh-private-key.age";
        owner = "eweishaar";
        mode = "0400";
      };
      age.identityPaths = map (e: e.path) (
        lib.filter (e: e.type == "rsa" || e.type == "ed25519") config.services.openssh.hostKeys
      );
      environment.systemPackages = [
        self.packages.x86_64-linux.helium-browser
        self.packages.x86_64-linux.audible2m4b
        pkgs.prusa-slicer
      ];
      networking = {
        hostName = "dominaria";
        firewall.enable = false;
        networkmanager.enable = true;
        enableIPv6 = false;
      };
      programs.ssh.extraConfig = ''
        IdentityFile ${config.age.secrets.eweishaar-ssh-private-key.path}
      '';
      users.users.eweishaar.extraGroups = [ config.users.groups.media.name ];
      nixpkgs.overlays = [ self.overlays.tokyonight-gtk-theme ];

      # https://github.com/NixOS/nixpkgs/issues/180175
      systemd.services.NetworkManager-wait-online.enable = lib.mkForce false;
      systemd.services.systemd-networkd-wait-online.enable = lib.mkForce false;

      # Add udev rules for Flipper Zero
      services.udev.extraRules = ''
        SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="5740", MODE="0666", GROUP="plugdev"
      '';
      system.stateVersion = "24.11";
    };
}
