{ ... }:
{
  flake.modules.homeManager.tmux =
    { pkgs, ... }:
    {
      programs.tmux = {
        enable = true;
        plugins = with pkgs.tmuxPlugins; [
          sensible
          vim-tmux-navigator
        ];
        keyMode = "vi";
        mouse = true;
      };
    };
}
