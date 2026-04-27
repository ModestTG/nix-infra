let
  # List of public keys
  host-kaladesh = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILpFEFYX8tYCEDdVTfKewl9zQoq3X3aQ+52DRTJdOL1x";
  host-dominaria = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHN0ufczBMP3d+ZtMyufxqHErAbotkf0S/RwPnR1MBYJ";
  host-vryn = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHlkQoTvWpRrLC21k2Z5imlCbeqqPE9a2V1LUN3dKEdJ";
  user-eweishaar = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIElkoT9GhRczgqRRpdC4gfw/z1eShyqto4AKQnk3nka6";

  keyList = [
    host-kaladesh
    host-dominaria
    host-vryn
    user-eweishaar
  ];
in
{
  # Create keys using `agenix -e <secretName>` from this folder
  "cf-dns-api-token.age".publicKeys = keyList;
  "eweishaar-ssh-private-key.age".publicKeys = keyList;
  "gatus-ntfy-token.age".publicKeys = keyList;
  "kaladesh-ssh-privateKey.age".publicKeys = keyList;
  "matrix-synapse-secrets.age".publicKeys = keyList;
  "ntfy-settings.age".publicKeys = keyList;
  "paperless-ngx-admin-password.age".publicKeys = keyList;
  "radarr-api-key.age".publicKeys = keyList;
  "radicale-users.age".publicKeys = keyList;
  "restic-password.age".publicKeys = keyList;
  "searxng-secret-key.age".publicKeys = keyList;
  "tailscale-preauth-key.age".publicKeys = keyList;
  "traefik-basic-auth-password.age".publicKeys = keyList;
  "turn-secrets.age".publicKeys = keyList;
  "vaultwarden-admin-token.age".publicKeys = keyList;
  "vps-ssh.age".publicKeys = keyList;
}
