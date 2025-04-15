{ config, ... }:
{
  services.fail2ban = {
    enable = config.services.openssh.enable;
    maxretry = 3;
    ignoreIP = [
      "127.0.0.1"
    ];
    bantime = "24h";
    bantime-increment = {
      enable = true;
      # Enable increment of bantime after each violation
      multipliers = "1 2 4 8 16 32 64";
      # Do not ban for more than 1 week
      maxtime = "168h";
      # Calculate the bantime based on all the violations
      overalljails = true;
    };
  };
}
