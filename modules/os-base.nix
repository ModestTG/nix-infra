{ inputs, self, ... }:
{
  flake.modules.nixos.osBase =
    { lib, ... }:
    {
      imports = with self.modules.nixos; [
        basePackages
        ntp
        users-eweishaar
      ];
      i18n.defaultLocale = "en_US.UTF-8";
      time.timeZone = "America/Chicago";
      users.mutableUsers = false;
      programs.appimage = {
        enable = true;
        binfmt = true;
      };
      programs.neovim.enable = true;
      environment = {
        enableAllTerminfo = true;
        shellAliases = {
          vim = "nvim";
          v = "nvim";
        };
      };
      nix =
        let
          flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
        in
        {
          settings = {
            connect-timeout = 5;
            log-lines = 25;
            min-free = 128000000; # 128MB
            max-free = 1000000000; # 1GB
            warn-dirty = false;
            experimental-features = [
              "nix-command"
              "flakes"
            ];
            substituters = [
              "https://cache.nixos.org"
              "https://colmena.cachix.org"
            ];
            trusted-public-keys = [ "colmena.cachix.org-1:7BzpDnjjH8ki2CT3f6GdOk7QAzPOl+1t3LvTLXqYcSg=" ];
          };
          channel.enable = false;
          nixPath = lib.mapAttrsToList (flakeName: _: "${flakeName}=flake:${flakeName}") flakeInputs;
          registry = lib.mapAttrs (_: flake: { inherit flake; }) flakeInputs;
          optimise = {
            automatic = true;
            dates = [ "03:00" ];
          };
        };
      nixpkgs = {
        config.allowUnfree = true;
        flake = {
          setFlakeRegistry = false;
          setNixPath = false;
        };
      };
    };
}
