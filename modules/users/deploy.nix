{ ewhs, ... }:
{
  flake.modules.nixos.users-deploy =
    { ... }:
    {
      users.users.deploy = {
        isNormalUser = true;
        extraGroups = [
          "wheel"
        ];
        openssh.authorizedKeys.keys = [ ewhs.const.deploySshPublicKey ];
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
