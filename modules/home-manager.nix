{ self, inputs, ... }:
{
  flake.modules.nixos.homeManagerBase =
    { ... }:
    {
      imports = [ inputs.home-manager.nixosModules.home-manager ];
      home-manager = {
        verbose = true;
        backupFileExtension = "hmbackup";
        overwriteBackup = true;
        useGlobalPkgs = true;
      };
    };
  flake.modules.homeManager.hmBase =
    { pkgs, ... }:
    {
      imports = with self.modules.homeManager; [
        bash
        git
        kitty
        nixvim
        starship
        tmux
      ];
      programs = {
        bat = {
          enable = true;
          extraPackages = [
            pkgs.bat-extras.batman
          ];
        };
        btop.enable = true;
        element-desktop.enable = true;
        eza = {
          enable = true;
          colors = "auto";
          extraOptions = [ "--group" ];
        };
        fastfetch.enable = true;
        home-manager.enable = true;
        mpv.enable = true;
        nushell.enable = true;
        ripgrep.enable = true;
        opencode.enable = true;
      };
      # Nicely reload system units when changing configs
      systemd.user.startServices = "sd-switch";
      xdg.enable = true;
    };
}
