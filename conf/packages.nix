  { config, pkgs, handy, noctalia, ... }:

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

  # Android studio
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    zlib
    stdenv.cc.cc.lib
    glib
    libGL
    freetype
    fontconfig
    ncurses5
    pipewire
  ];

  environment.systemPackages = with pkgs; [
    # Browsers
    microsoft-edge

    # file manager
    nautilus

    flameshot
    vlc

    handy.packages.x86_64-linux.handy
    noctalia.packages.x86_64-linux.default

    btop
    tailscale

    #Handy
    wtype
    claude-code

    #chat
    telegram-desktop
    # (signal-desktop.overrideAttrs (oldAttrs: {
    #   preFixup = (oldAttrs.preFixup or "") + ''
    #     gappsWrapperArgs+=(--add-flags "--password-store=gnome-libsecret")
    #   '';
    # }))
    signal-desktop
    discord


    # editors
    neovim
    helix
    vscode
    jetbrains.idea

    # Kotlin
    android-studio
    jdk21
    android-tools
    kotlin

    wireguard-tools
    git
    kitty

    openrazer-daemon

    ouch

    # Sway
    wl-clipboard
    grim
    slurp
    sway-contrib.grimshot
    swappy
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
