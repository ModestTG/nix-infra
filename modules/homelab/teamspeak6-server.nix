{ ... }:
{
  flake.modules.nixos.homelab-teamspeak6-server = {
    virtualisation.oci-containers.containers.teamspeak6-server = {
      hostname = "teamspeak6";
      image = "teamspeaksystems/teamspeak6-server:latest";
      volumes = [
        "/var/lib/teamspeak6-server:/var/tsserver"
      ];
      ports = [
        "9987:9987/udp"
        "30033:30033/udp"
      ];
      environment = {
        TSSERVER_LICENSE_ACCEPTED = "accept";
        TSSERVER_VOICE_IP = "0.0.0.0";
        TSSERVER_FILE_TRANSFER_PORT = "30033";
        TSSERVER_FILE_TRANSFER_IP = "0.0.0.0";
      };
    };
    system.activationScripts.teamspeak6-dir =
      #bash
      ''
        if [ ! -d /var/lib/teamspeak6-server ]; then
        	mkdir -p /var/lib/teamspeak6-server;
        	chown -R 9987:9987 /var/lib/teamspeak6-server;
        fi
      '';
  };
}
