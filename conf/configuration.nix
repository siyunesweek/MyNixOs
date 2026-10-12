{ config, pkgs, ... }:

{
  imports =
    [ 
      # Basic cofiguration
      ./hardware-configuration.nix
      ./boot.nix
      ./audio.nix
      # ./desktop.nix
      ./locale.nix
      ./users.nix
      ./network.nix
      ./packages.nix
      ./bluetooth.nix
      ./bash.nix

      # NVIDIA
      ./nvidia.nix

      ./configs.nix

      # Sway
      ./sway.nix
      ./sconfig.nix

      # Fcitx5
      ./fcitx5.nix

      # ./autofirma.nix
      ./desktops.nix
      ./neovim.nix

      #vpn
      ./tailscale.nix

      ./niri.nix
      ./river.nix
      ./muei.nix

    ];

    nix.settings.experimental-features = [ "nix-command" ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?
  services.upower.enable = true;

}

