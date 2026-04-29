{ self, inputs, ... }:
{
  flake.modules.nixos.desktopAlpha =
    { ... }:
    {
      imports = with self.modules.nixos; [
        desktopBase
        gaming
        swayWm
        ly
      ];
      home-manager.users.eweishaar.imports = with self.modules.homeManager; [
        ssh
      ];
    };
  flake.modules.nixos.desktopBase =
    { pkgs, ... }:
    {
      imports = [
        inputs.stylix.nixosModules.stylix
        self.modules.nixos.users-eweishaar-hm
      ];
      home-manager.users.eweishaar.imports = [ self.modules.homeManager.desktopBase ];
      environment.systemPackages = with pkgs; [
        discord
        feishin
        freecad-wayland
        gthumb
        immich-go
        libreoffice
        mqtt-explorer
        pamixer
        pavucontrol
        picard
        podman-desktop
        pulseaudio
        qFlipper
        (self.packages.${pkgs.stdenv.hostPlatform.system}.spotiflac)
        signal-desktop
        spotify
        thunar
        tumbler
        wireshark
      ];
      hardware.bluetooth = {
        enable = true;
        powerOnBoot = true;
      };
      programs = {
        dconf.enable = true;
        nh = {
          enable = true;
          clean = {
            enable = true;
            extraArgs = "--keep-since 10d --keep 5";
          };
        };
        yubikey-manager.enable = true;
      };
      nixpkgs.overlays = [ self.overlays.tokyonight-gtk-theme ];
      security = {
        pam.services.login.enableGnomeKeyring = true;
        polkit.enable = true;
        rtkit.enable = true;
      };
      services = {
        blueman.enable = true;
        dbus.enable = true;
        devmon.enable = true;
        gnome.gnome-keyring.enable = true;
        gvfs.enable = true;
        pcscd.enable = true;
        pipewire = {
          enable = true;
          alsa.enable = true;
          alsa.support32Bit = true;
          pulse.enable = true;
          wireplumber.enable = true;
          jack.enable = true;
        };
        pulseaudio.enable = false;
        udev.packages = [ pkgs.yubikey-personalization ];
        udisks2.enable = true;
      };
      stylix = {
        enable = true;
        base16Scheme = "${pkgs.base16-schemes}/share/themes/eighties.yaml";
        fonts = {
          monospace = {
            package = pkgs.nerd-fonts.fira-code;
            name = "FiraCode Nerd Font Propo";
          };
        };
        cursor = {
          package = pkgs.vimix-cursors;
          name = "Vimix-cursors";
          size = 22;
        };
        opacity = {
          terminal = 0.9;
          popups = 0.9;
        };
      };
    };
  flake.modules.homeManager.desktopBase =
    { pkgs, ... }:
    {
      stylix = {
        icons = {
          enable = true;
          package = pkgs.tokyonight-gtk-theme;
          dark = "Tokyonight-Dark";
          light = "Tokyonight-Light";
        };
        targets.nixvim.transparentBackground = {
          main = true;
          numberLine = true;
          signColumn = true;
        };
      };
      programs.feh.enable = true;
      programs.obsidian.enable = true;
      programs.yt-dlp.enable = true;
      programs.zathura.enable = true;
      services.flameshot = {
        enable = true;
        package = pkgs.flameshot.override {
          enableWlrSupport = true;
        };
        settings = {
          General = {
            showStartupLaunchMessage = false;
            disabledTrayIcon = true;
          };
        };
      };
    };
}
