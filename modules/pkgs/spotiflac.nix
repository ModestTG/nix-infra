{
  perSystem =
    { pkgs, ... }:
    let
      pname = "spotiflac";
      version = "v7.1.0";
      src = builtins.fetchurl {
        url = "https://github.com/afkarxyz/SpotiFLAC/releases/download/${version}/SpotiFLAC.AppImage";
        sha256 = "0cfk8y0hvl6sgsfd1d4rdql8an6kskxs13f69yf956hpfs0lhb9g";
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
