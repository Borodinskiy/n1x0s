{
  networking.firewall = {
    enable = true;

    # Used for tun interfaces so they will work ¯\_(ツ)_/¯
    checkReversePath = false;

    allowedTCPPorts = [
      22000 # Syncthing
      25565 # Minecraft server
      16261 # Project zomboid
    ];

    allowedUDPPorts = [
      22000
      21027 # Syncthing
      25565 # Minecraft server
      16261 # Project zomboid
    ];
  };
}
