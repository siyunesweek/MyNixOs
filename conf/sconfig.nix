{ config, lib, pkgs, ... }:

{
  # Start on tty
  environment.loginShellInit = ''
    if [ -z "$WAYLAND_DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
      read -p "Start Sway? [y]es or [n]o: " -n 1 -r
      echo
      if [[ $REPLY =~ ^[Yy]$ ]]; then
        exec sway
      fi
    fi
  '';

  # Autologin
  services.getty.autologinUser = "agamotto";
  services.getty.autologinOnce = true;

  # Reglas udev: alias de GPU + permisos de backlight
  services.udev.extraRules = ''
    SUBSYSTEM=="drm", KERNEL=="card*", DRIVERS=="amdgpu", SYMLINK+="dri/igpu"
    SUBSYSTEM=="drm", KERNEL=="card*", DRIVERS=="nvidia", SYMLINK+="dri/dgpu"

    ACTION=="add", SUBSYSTEM=="backlight", RUN+="${pkgs.coreutils}/bin/chgrp video /sys/class/backlight/%k/brightness", RUN+="${pkgs.coreutils}/bin/chmod g+w /sys/class/backlight/%k/brightness"
  '';

  hardware.brillo.enable = true;
  users.users.agamotto.extraGroups = [ "video" ];

  services.libinput.enable = true;
  services.printing.enable = true;

  # SwayFX
  programs.sway = {
    enable = true;
    package = pkgs.swayfx;
    wrapperFeatures.gtk = true;

    # Quita la queja de sway por drivers propietarios
    extraOptions = [ "--unsupported-gpu" ];

    extraSessionCommands = ''
      export WLR_DRM_DEVICES=/dev/dri/igpu:/dev/dri/dgpu
      export NIXOS_OZONE_WL=1
      export MOZ_ENABLE_WAYLAND=1
      export QT_QPA_PLATFORM=wayland
      export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
      export SDL_VIDEODRIVER=wayland
      export _JAVA_AWT_WM_NONREPARENTING=1
      export XDG_CURRENT_DESKTOP=sway
      export XDG_SESSION_TYPE=wayland
    '';

    extraPackages = with pkgs; [
      swaylock
      swayidle
      swaybg
      wmenu
      foot
      mako
      adwaita-icon-theme
      gnome-themes-extra
    ];
  };

  # keys
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.sway.default = lib.mkForce [ "wlr" "gtk" ];
  };

  services.gnome.gnome-keyring.enable = true;
  security.pam.services.login.enableGnomeKeyring = true;
  security.pam.services.swaylock = { };

  programs.dconf.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-color-emoji
    nerd-fonts.jetbrains-mono
  ];
}
