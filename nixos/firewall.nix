let
  ports = [
    22000 # Syncthing
    21027 # Syncthing
    25565 # Minecraft server
    16261 # Project zomboid
    42420 # Vintage story
  ];
in
{
  networking.firewall = {
    enable = true;

    # Used for tun interfaces so they will work ¯\_(ツ)_/¯
    checkReversePath = false;

    allowedTCPPorts = ports;
    allowedUDPPorts = ports;
  };
}
