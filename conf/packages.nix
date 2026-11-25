  { config, pkgs, lib, ... }:

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


    python3
    python3Packages.dbus-python
    networkmanagerapplet
    docker
    just

    # file manager
    nautilus

    flameshot
    vlc

    handy
    # noctalia
    gh

    btop
    tailscale

    #Handy
    wtype
    claude-code

    #chat
    telegram-desktop
    # Forzamos gnome-libsecret: no usamos KWallet (ver kde.nix), y sin esto
    # Electron intenta activar kwalletd6 por D-Bus y falla con errores en consola.
    (signal-desktop.overrideAttrs (old: {
      postFixup = (old.postFixup or "") + ''
        wrapProgram $out/bin/signal-desktop --add-flags "--password-store=gnome-libsecret"
      '';
    }))
    discord
    wechat

    thunderbird


    # editors
    neovim
    helix
    vscode
    jetbrains.idea
    siyuan
    libreoffice

    # Kotlin
    android-studio
    jdk21
    (lib.lowPrio jdk17)
    android-tools
    kotlin

    wireguard-tools
    git
    kitty

    ouch
    papers

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
    
    # Node
    nodejs
    pnpm

    kdePackages.okular

    fastfetch

    wget

    spark

  ];


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
}
