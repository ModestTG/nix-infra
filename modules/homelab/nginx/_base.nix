self:
{
  config,
  pkgs-unstable,
  dnsPropagationCheck ? true,
  extraLegoFlags ? [ ],
  ...
}:
{
  age.secrets.cf-dns-api-token.file = builtins.toPath "${self.outPath}/secrets/cf-dns-api-token.age";
  security.acme = {
    acceptTerms = true;
    certs."ewhomelab.com" = {
      email = "elliotweishaar27@gmail.com";
      dnsProvider = "cloudflare";
      dnsResolver = "1.1.1.1:53";
      inherit dnsPropagationCheck extraLegoFlags;
      credentialFiles."CF_DNS_API_TOKEN_FILE" = config.age.secrets.cf-dns-api-token.path;
      extraDomainNames = [ "*.ewhomelab.com" ];
    };
  };
  services.nginx = {
    enable = true;
    package = pkgs-unstable.nginxMainline;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    recommendedOptimisation = true;
  };
  users.users.nginx.extraGroups = [ config.security.acme.defaults.group ];
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}
