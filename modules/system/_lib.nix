{
  mkProxyVirtualHost =
    {
      port,
      host ? "localhost",
      scheme ? "http",
      acmeHost ? "ewhomelab.com",
      websockets ? true,
      extraConfig ? null,
    }:
    {
      forceSSL = true;
      useACMEHost = acmeHost;
      locations."/" = {
        proxyPass = "${scheme}://${host}:${toString port}";
        proxyWebsockets = websockets;
      } // (if extraConfig != null then { inherit extraConfig; } else { });
    };
}
