{
  ewhs,
  inputs,
  self,
  ...
}:
{
  flake.modules.homeManager.ssh =
    { config, osConfig, ... }:
    {
      imports = [ inputs.agenix.homeManagerModules.default ];
      age = {
        identityPaths = [ osConfig.age.secrets.eweishaar-ssh-private-key.path ];
        secrets = {
          vps-ssh.file = builtins.toPath "${self.outPath}/secrets/vps-ssh.age";
          deploy-ssh-private-key.file = builtins.toPath "${self.outPath}/secrets/deploy-ssh-private-key.age";
        };
      };
      programs.ssh = {
        enable = true;
        enableDefaultConfig = false;
        matchBlocks = {
          "kaladesh" = {
            hostname = ewhs.const.kaladeshIP;
            user = "eweishaar";
            identitiesOnly = true;
          };
          "kaladesh-deploy" = {
            hostname = ewhs.const.kaladeshIP;
            user = "deploy";
            identityFile = config.age.secrets.deploy-ssh-private-key.path;
            identitiesOnly = true;
          };
          "vryn" = {
            user = "deploy";
            identityFile = config.age.secrets.deploy-ssh-private-key.path;
            identitiesOnly = true;
          };
        };
        extraOptionOverrides = {
          Include = config.age.secrets.vps-ssh.path;
        };
      };
    };
  flake.modules.nixos.ssh =
    { ... }:
    {
      services.openssh = {
        enable = true;
        openFirewall = true;
        settings = {
          PasswordAuthentication = false;
          PermitRootLogin = "no";
          KexAlgorithms = [
            "sntrup761x25519-sha512@openssh.com"
            "curve25519-sha256"
            "curve25519-sha256@libssh.org"
            "diffie-hellman-group18-sha512"
            "diffie-hellman-group-exchange-sha256"
            "diffie-hellman-group14-sha256"
          ];
        };
      };
    };
}
