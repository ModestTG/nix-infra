{ ... }:
{
  flake.modules.homeManager.git =
    { ... }:
    {
      programs.git = {
        enable = true;
        signing.format = "openpgp";
        settings = {
          user.name = "ModestTG";
          user.email = "ssh@mailserver.com";
          init.defaultBranch = "main";
          safe.directory = "/home/eweishaar/nix-infra";
        };
      };
      programs.lazygit.enable = true;
    };
}
