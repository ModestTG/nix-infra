{
  perSystem =
    { pkgs, ... }:
    let
      pname = "helium-browser";
      version = "0.11.5.1";
      arch = "x86_64";
      src = builtins.fetchurl {
        url = "https://github.com/imputnet/helium-linux/releases/download/${version}/helium-${version}-${arch}.AppImage";
        sha256 = "0n3n50bqwz028iims89qjacaba9aj43720fdnbzgls81smkwhbin";
      };
      appImageContents = pkgs.appimageTools.extract { inherit pname version src; };
    in
    {
      packages.helium-browser = pkgs.appimageTools.wrapType2 {
        inherit pname version src;
        extraInstallCommands = ''
          install -m 444 -D ${appImageContents}/helium.desktop -t $out/share/applications
          substituteInPlace $out/share/applications/helium.desktop --replace 'Exec=AppRun' 'Exec=${pname}'
          install -m 444 -D ${appImageContents}/helium.png $out/share/icons/hicolor/256x256/apps/helium.png
        '';
      };
    };
}
