{ ... }:
{
  flake.modules.homeManager.wofi =
    { ... }:
    {
      programs.wofi = {
        enable = true;
        settings = {
          mode = "drun";
          allow_images = true;
          width = "35%";
          key_expand = "space";
          key_down = "Ctrl-j";
          key_up = "Ctrl-k";
          key_right = "Ctrl-l";
          key_left = "Ctrl-h";
        };
      };
    };
}
