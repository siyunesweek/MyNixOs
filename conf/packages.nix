{ config, pkgs, ... }:
let
  unstable = import <nixos-unstable> { config = config.nixpkgs.config; };
in
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

    flameshot

    btop

    #chat
    telegram-desktop
    (signal-desktop.overrideAttrs (oldAttrs: {
      preFixup = (oldAttrs.preFixup or "") + ''
        gappsWrapperArgs+=(--add-flags "--password-store=gnome-libsecret")
      '';
    }))
    discord


    # editors
    neovim
    helix

    wireguard-tools
    git
    kitty

    openrazer-daemon

    # Sway
    wl-clipboard
    grim
    slurp
    sway-contrib.grimshot
    playerctl
    pavucontrol
    mako
    pciutils
    vicinae

  ] ++ [
    unstable.noctalia
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
}
