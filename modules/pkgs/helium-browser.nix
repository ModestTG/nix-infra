{
  perSystem =
    { pkgs, ... }:
    let
      pname = "helium-browser";
      version = "0.9.4.1";
      arch = "x86_64";
      src = builtins.fetchurl {
        url = "https://github.com/imputnet/helium-linux/releases/download/${version}/helium-${version}-${arch}.AppImage";
        sha256 = "1s4yhbzcmh9wwg5mnk19m72r48px7259vy0z4yfqpb2fxid1v61p";
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
