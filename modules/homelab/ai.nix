{ ... }:
{
  flake.modules.nixos.homelab-ollama-cuda =
    { pkgs-unstable, ... }:
    {
      services.ollama = {
        enable = true;
        package = pkgs-unstable.ollama-cuda;
        loadModels = [
          "qwen3.5:27b"
        ];
      };
      services.open-webui = {
        enable = true;
        package = pkgs-unstable.open-webui;
        host = "0.0.0.0";
        port = 8084;
      };
    };
}
