{ ... }:
{
  flake.modules.nixos.users-deploy =
    { config, ... }:
    {
      users.users.deploy = {
        isNormalUser = true;
        extraGroups = [
          "wheel"
        ];
        openssh.authorizedKeys.keys = [ config.systemConstants.deployPublicSshKey ];
      };
      security.sudo = {
        keepTerminfo = true;
        extraRules = [
          {
            users = [ "deploy" ];
            commands = [
              {
                command = "ALL";
                options = [ "NOPASSWD" ];
              }
            ];
          }
        ];
      };
    };
}
