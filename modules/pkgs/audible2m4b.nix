{
  perSystem =
    { pkgs, ... }:
    {
      packages.audible2m4b = pkgs.writeShellApplication {
        name = "audible2m4b";
        runtimeInputs = [ pkgs.ffmpeg ];
        text = ''
          ffmpeg -y -activation_bytes dfa8f705 -i "$1" -c copy output.m4b
        '';
      };
    };
}
