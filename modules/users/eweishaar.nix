{
  ewhs,
  inputs,
  self,
  ...
}:
{
  flake.modules.nixos.users-eweishaar =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      users.users.eweishaar = {
        isNormalUser = true;
        # generated with `mkpasswd -m scrypt`
        initialHashedPassword = "$7$CU..../....i89TMSGgWw3qQucMUF3WQ/$NbRbMXyTiIM2jMaxKS1vHhTtZ1M7SgbB16eltu2ZYk7";
        extraGroups = [
          "dialout"
          "wheel"
        ];
        uid = 1000;
        shell = pkgs.bashInteractive;
        openssh.authorizedKeys.keys = [ ewhs.const.eweishaarSshPublicKey ];
      };
      security.sudo = lib.mkIf config.security.sudo.enable {
        keepTerminfo = true;
        extraRules = [
          {
            users = [ "eweishaar" ];
            commands = [ "ALL" ];
          }
        ];
      };
      security.doas.extraRules = lib.mkIf config.security.doas.enable [
        {
          users = [ "eweishaar" ];
          persist = true;
          keepEnv = true;
        }
      ];
    };
  flake.modules.nixos.users-eweishaar-hm =
    { config, ... }:
    {
      imports = [ self.modules.nixos.homeManagerBase ];
      home-manager.users.eweishaar = {
        imports = [
          self.modules.homeManager.hmBase
          inputs.agenix.homeManagerModules.default
        ];
        home = {
          username = "eweishaar";
          homeDirectory = "/home/eweishaar";
          stateVersion = config.system.stateVersion;
          sessionVariables = {
            EDITOR = "nvim";
          };
        };
      };
    };
}
