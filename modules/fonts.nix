{ ... }:
{
  flake.modules.homeManager.nerdFonts =
    { pkgs, ... }:
    {
      fonts.fontconfig.enable = true;
      home.packages = with pkgs; [
        font-awesome
        fira-code-symbols
      ];
    };
}
