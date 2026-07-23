{ config, pkgs, ... }:

{
  networking.hostName = "nixos";

  # Enable networking
  networking.networkmanager.enable = true;
  networking.wireguard.enable = true;

  networking.wg-quick.interfaces.wg0 = {
    autostart = true;
    configFile = "/etc/wireguard/wg0.conf";
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

}
