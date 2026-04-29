rec {
  const = {
    eweishaarSshPublicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIElkoT9GhRczgqRRpdC4gfw/z1eShyqto4AKQnk3nka6";
    deploySshPublicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINexaBnm9WRlQ2Kb2xq6m9Z0ekUsTz1nxWxDHjn/0MgC";
    nasIP = "10.0.0.8";
    kaladeshIP = "10.0.20.22";
    shellAliases = {
      cat = "bat";
      k = "kubectl";
      lg = "lazygit";
      ll = "eza -lg";
      ls = "eza";
      man = "batman";
      sctl = "systemctl";
      sctlu = "systemctl --user";
      s = "systemctl";
      sudo = "doas";
      vim = "nvim";
      v = "nvim";
    };
  };
  lib = {
    mkResticBackup =
      {
        name,
        paths,
        passwordFile,
        nasIP ? const.nasIP,
        pruneOpts ? [
          "--keep-daily 14"
          "--keep-monthly 6"
          "--keep-yearly 1"
        ],
      }:
      {
        repository = "sftp:root@${nasIP}:/mnt/AuxPool/K8S-NFS/backups/${name}";
        inherit paths passwordFile pruneOpts;
        initialize = true;
      };
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
        }
        // (if extraConfig != null then { inherit extraConfig; } else { });
      };
  };
}
