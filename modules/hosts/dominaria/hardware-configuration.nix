{ ... }:
{
  flake.modules.nixos.dominariaHardwareConfiguration =
    {
      config,
      lib,
      pkgs,
      modulesPath,
      ...
    }:

    {
      imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

      boot = {
        initrd = {
          availableKernelModules = [
            "xhci_pci"
            "nvme"
            "ahci"
            "usbhid"
            "sd_mod"
          ];
          kernelModules = [ ];
        };
        # Enable BBR congestion control
        # see https://news.ycombinator.com/item?id=14814530
        kernel.sysctl = {
          "net.ipv4.tcp_congestion_control" = "bbr";
          "net.core.default_qdisc" = "fq";
        };
        kernelModules = [
          "kvm-amd"
          "tcp_bbr"
          "sg" # need for USB CDROM support
        ];
        kernelPackages = pkgs.linuxPackages_latest;
        kernelParams = [ "pcie_port_pm=off" ];
        loader = {
          systemd-boot.enable = false;
          efi = {
            canTouchEfiVariables = true;
            efiSysMountPoint = "/boot";
          };
          grub = {
            enable = true;
            device = "nodev";
            useOSProber = true;
            efiSupport = true;
          };
        };
        # Needed for appimage manipulation
        supportedFilesystems = [ "fuse" ];
      };

      fileSystems."/" = {
        device = "/dev/disk/by-uuid/3b290d30-5602-4b04-8855-ac05eaabc28e";
        fsType = "ext4";
      };

      fileSystems."/boot" = {
        device = "/dev/disk/by-uuid/BC64-F152";
        fsType = "vfat";
        options = [
          "fmask=0077"
          "dmask=0077"
        ];
      };
      swapDevices = [ ];
      networking.useDHCP = lib.mkDefault true;
      nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
      hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    };
}
