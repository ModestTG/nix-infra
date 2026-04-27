rec {
  domain = "ewhomelab.com";
  matrixDomain = "matrix.${domain}";
  turnDomain = "turn.${domain}";

  # Shared nginx well-known locations for Matrix discovery
  wellKnownLocations = {
    "= /.well-known/matrix/client".extraConfig = ''
      default_type application/json;
      add_header Access-Control-Allow-Origin "*";
      return 200 '${
        builtins.toJSON {
          "m.homeserver" = {
            base_url = "https://${matrixDomain}";
          };
        }
      }';
    '';
    "= /.well-known/matrix/server".extraConfig = ''
      default_type application/json;
      return 200 '${
        builtins.toJSON {
          "m.server" = "${matrixDomain}:443";
        }
      }';
    '';
  };
}
