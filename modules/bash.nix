{ ... }:
{
  flake.modules.homeManager.bash =
    { osConfig, ... }:
    {
      programs.bash = {
        enable = true;
        shellAliases = osConfig.systemConstants.shellAliases;
      };
    };
}
