{ ewhs, ... }:
{
  flake.modules.homeManager.bash =
    { ... }:
    {
      programs.bash = {
        enable = true;
        shellAliases = ewhs.const.shellAliases;
      };
    };
}
