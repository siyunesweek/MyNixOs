{ config, pkgs, ... }:

{
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Limitar el menú de arranque a las 10 últimas generaciones
  boot.loader.systemd-boot.configurationLimit = 20;
  boot.loader.timeout = 15;
  
  # Recolector de basura automático semanal
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  # Deduplicar el store
  nix.settings.auto-optimise-store = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;
  # boot.kernelPackages = pkgs.linuxPackages_6_12;
}
