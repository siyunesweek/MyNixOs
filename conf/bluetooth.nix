{ config, pkgs, ... }:

{
  # Habilita el soporte de Bluetooth a nivel de sistema.
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true; # enciende el adaptador automáticamente al arrancar
  };

  services.blueman.enable = true;
}
