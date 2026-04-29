{ self, ... }:
{
  flake.modules.generic.homeLab =
    { ... }:
    {
      _module.args.homeLab = import (self + "/modules/system/_lib.nix");
    };
  flake.modules.generic.systemConstants =
    { lib, ... }:
    {
      options.systemConstants = lib.mkOption {
        type = lib.types.attrsOf lib.types.unspecified;
        default = { };
      };

      config.systemConstants = {
        eweishaarPublicSshKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIElkoT9GhRczgqRRpdC4gfw/z1eShyqto4AKQnk3nka6";
        deployPublicSshKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINexaBnm9WRlQ2Kb2xq6m9Z0ekUsTz1nxWxDHjn/0MgC";
        nasIP = "10.0.0.8";
        kaladeshIP = "10.0.20.22";
        shellAliases = {
          cat = "bat";
          k = "kubectl";
          lg = "lazygit";
          ll = "eza -lg";
          ls = "eza";
          man = "batman";
          sctl = "systemctl";
          sctlu = "systemctl --user";
          s = "systemctl";
          sudo = "doas";
          vim = "nvim";
          v = "nvim";
        };
      };
    };
}
