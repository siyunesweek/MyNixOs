{ config, pkgs, ... }:

{
  imports =
    [ 
      # Homemanager
	<home-manager/nixos>

      # Basic cofiguration
      ./hardware-configuration.nix
      ./boot.nix
      ./audio.nix
      ./desktop.nix
      ./locale.nix
      ./users.nix
      ./network.nix
      ./packages.nix
      ./bluetooth.nix


      ./editors.nix
    ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

}

