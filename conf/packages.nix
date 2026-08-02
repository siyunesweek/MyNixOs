{ config, pkgs, ... }:

{

  # Install brillo
  hardware.brillo.enable = true;
  users.users.agamotto.extraGroups = [ "video" ];

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
  };

  environment.systemPackages = with pkgs; [

    # file manager
    nautilus

	  btop

    # editors
	  neovim
    helix

	  wireguard-tools
	  git
    kitty

    # Sway
    noctalia
    wl-clipboard
    grim
    slurp
    sway-contrib.grimshot
    playerctl
    pavucontrol
    mako
    pciutils    
    vicinae
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

}
