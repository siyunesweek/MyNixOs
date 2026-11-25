{ config, pkgs, lib, ... }:

{
  services = {
    desktopManager.plasma6.enable = true;

    # Default display manager for Plasma
    displayManager.plasma-login-manager.enable = true;

    # Optionally enable xserver
    # xserver.enable = true;
  };

  # Autologin (sesión por defecto: Plasma)
  services.displayManager.defaultSession = "plasma";
  # services.displayManager.autoLogin = {
  #   enable = true;
  #   user = "agamotto";
  # };

  # Reglas udev: alias de GPU + permisos de backlight
  services.udev.extraRules = ''
    SUBSYSTEM=="drm", KERNEL=="card*", DRIVERS=="amdgpu", SYMLINK+="dri/igpu"
    SUBSYSTEM=="drm", KERNEL=="card*", DRIVERS=="nvidia", SYMLINK+="dri/dgpu"

    ACTION=="add", SUBSYSTEM=="backlight", RUN+="${pkgs.coreutils}/bin/chgrp video /sys/class/backlight/%k/brightness", RUN+="${pkgs.coreutils}/bin/chmod g+w /sys/class/backlight/%k/brightness"
  '';

  hardware.brillo.enable = true;

  services.libinput.enable = true;
  services.printing.enable = true;

  # Portales XDG (necesarios también para la sesión niri)
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  services.gnome.gnome-keyring.enable = true;
  programs.seahorse.enable = true;


  # Desactiva KWallet: usamos gnome-keyring para guardar secretos
  security.pam.services.login.kwallet.enable = lib.mkForce false;
  security.pam.services.kde.kwallet.enable = lib.mkForce false;

  environment.etc."xdg/kwalletrc".text = ''
    [Wallet]
    Enabled=false
  '';

  programs.dconf.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-color-emoji
    nerd-fonts.jetbrains-mono
  ];
}
