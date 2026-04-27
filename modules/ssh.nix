{ self, inputs, ... }:
{
  flake.modules.homeManager.ssh =
    { config, ... }:
    {
      imports = [ inputs.agenix.homeManagerModules.default ];
      age.secrets.vps-ssh = {
        file = builtins.toPath "${self.outPath}/secrets/vps-ssh.age";
      };
      programs.ssh = {
        enable = true;
        matchBlocks = {
          "kaladesh" = {
            hostname = "10.0.20.22";
            user = "eweishaar";
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
