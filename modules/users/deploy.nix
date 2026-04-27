{ ... }:
{
  flake.modules.nixos.users-deploy =
    { ... }:
    {
      users.users.deploy = {
        isNormalUser = true;
        extraGroups = [
          "wheel"
        ];
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
