{
  perSystem =
    { pkgs, ... }:
    let
      pname = "spotiflac";
      version = "v7.1.6";
      src = builtins.fetchurl {
        url = "https://github.com/afkarxyz/SpotiFLAC/releases/download/${version}/SpotiFLAC.AppImage";
        sha256 = "1zd8sb1gmcbiy3a472a6as8fb2r7vszx0qvgzksqc7fxbb7w6axg";
      };
      appImageContents = pkgs.appimageTools.extract { inherit pname version src; };
    in
    {
      packages.spotiflac = pkgs.appimageTools.wrapType2 {
        inherit pname version src;
        extraPkgs = pkgs: with pkgs; [ webkitgtk_4_1 ];
        extraInstallCommands = ''
          install -m 444 -D ${appImageContents}/spotiflac.desktop -t $out/share/applications
          substituteInPlace $out/share/applications/spotiflac.desktop --replace 'Exec=SpotiFLAC' 'Exec=${pname}'
          install -m 444 -D ${appImageContents}/spotiflac.png $out/share/icons/hicolor/256x256/apps/spotiflac.png
        '';
      };
    };
}
