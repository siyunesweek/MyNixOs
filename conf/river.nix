{ config, lib, pkgs, ... }:

{
  # river-classic: es el proyecto que Nixpkgs sigue llamando "river"
  # (riverctl + rivertile), continuación del river clásico basado en
  # layouts externos vía riverctl. El "river" nuevo en Nixpkgs es una
  # reescritura sin riverctl, así que usamos explícitamente river-classic.
  programs.river-classic.enable = true;
  programs.river-classic.xwayland.enable = true;
  # No necesitamos foot/dmenu (usamos kitty/vicinae) ni swaylock
  # (ya lo instala sconfig.nix vía programs.sway.extraPackages).
  programs.river-classic.extraPackages = [ ];

  environment.systemPackages = with pkgs; [
    wlr-randr
  ];

  environment.etc."river/init" = {
    mode = "0755";
    text = ''
      #!${pkgs.runtimeShell}
      # Sin "set -e": si un riverctl falla (p.ej. un dispositivo que no
      # existe en esta máquina) el resto de bindings se siguen aplicando.

      mod=Mod1

      term=kitty
      menu="vicinae toggle"
      file=nautilus
      browser=firefox

      ###############################################################
      # Input
      ###############################################################
      riverctl keyboard-layout cn

      # river no soporta selectores genéricos "type:touchpad" como sway;
      # aplicamos los ajustes a cualquier dispositivo cuyo identificador
      # contenga "touchpad".
      riverctl list-inputs 2>/dev/null | grep -i touchpad | while read -r id; do
        riverctl input "$id" tap enabled
        riverctl input "$id" natural-scroll enabled
        riverctl input "$id" disable-while-typing enabled
        riverctl input "$id" accel-profile flat
      done

      ###############################################################
      # Outputs
      # river no configura salidas por riverctl (no hay protocolo core
      # para eso); usamos wlr-randr, igual de estático que los bloques
      # "output" de sway/niri.
      ###############################################################
      wlr-randr --output "HDMI-A-1" --mode 2560x1440@143.991Hz --pos 0,0 --scale 1 || true
      wlr-randr --output "Samsung Display Corp. ATNA40CU05-0 Unknown" --mode 2880x1800@120.000Hz --pos 2560,0 --scale 1.5 || true

      ###############################################################
      # Apariencia
      ###############################################################
      riverctl border-width 2
      riverctl border-color-focused 0x4c7899
      riverctl border-color-unfocused 0x333333
      riverctl background-color 0x000000
      riverctl xcursor-theme Adwaita 24

      riverctl default-layout rivertile
      riverctl spawn "rivertile -view-padding 8 -outer-padding 4 -main-ratio 0.55"

      ###############################################################
      # Autostart
      ###############################################################
      riverctl spawn mako
      riverctl spawn "dbus-update-activation-environment --all"
      riverctl spawn "vicinae server"
      riverctl spawn noctalia
      riverctl spawn "dbus-update-activation-environment --systemd --all"
      riverctl spawn "gnome-keyring-daemon --start --components=pkcs11,secrets,ssh"
      riverctl spawn "fcitx5 -d"
      riverctl spawn handy

      ###############################################################
      # Keybindings
      ###############################################################
      riverctl map normal $mod Return spawn $term
      riverctl map normal $mod R spawn "$menu"
      riverctl map normal $mod Q close
      riverctl map normal $mod+Control M exit

      riverctl map normal $mod F spawn $file
      riverctl map normal $mod B spawn $browser
      riverctl map normal $mod comma spawn "pkill -USR2 -n handy"
      riverctl map normal $mod+Shift R spawn "pkill vicinae; vicinae server &"

      # Foco / orden de ventanas (river no tiene foco direccional h/j/k/l
      # nativo: solo cicla por el orden de la pila, que en rivertile
      # coincide con el orden de tiling)
      riverctl map normal $mod J focus-view next
      riverctl map normal $mod K focus-view previous
      riverctl map normal $mod Tab focus-view next
      riverctl map normal $mod+Shift Tab focus-view previous

      riverctl map normal $mod+Shift J swap next
      riverctl map normal $mod+Shift K swap previous

      riverctl map normal $mod period focus-output next
      riverctl map normal $mod comma focus-output previous
      riverctl map normal $mod+Shift period send-to-output next
      riverctl map normal $mod+Shift comma send-to-output previous

      # Tags (equivalente a workspaces 1-10; river usa una máscara de bits)
      i=1
      while [ $i -le 9 ]; do
        tags=$((1 << (i - 1)))
        riverctl map normal $mod $i set-focused-tags $tags
        riverctl map normal $mod+Shift $i set-view-tags $tags
        riverctl map normal $mod+Control $i toggle-focused-tags $tags
        riverctl map normal $mod+Shift+Control $i toggle-view-tags $tags
        i=$((i + 1))
      done
      all_tags=$(((1 << 32) - 1))
      riverctl map normal $mod 0 set-focused-tags $all_tags
      riverctl map normal $mod+Shift 0 set-view-tags $all_tags

      # Layout (rivertile)
      riverctl map normal $mod H send-layout-cmd rivertile "main-ratio -0.05"
      riverctl map normal $mod L send-layout-cmd rivertile "main-ratio +0.05"
      riverctl map normal $mod+Shift H send-layout-cmd rivertile "main-count +1"
      riverctl map normal $mod+Shift L send-layout-cmd rivertile "main-count -1"
      riverctl map normal $mod+Control Up send-layout-cmd rivertile "main-location top"
      riverctl map normal $mod+Control Down send-layout-cmd rivertile "main-location bottom"
      riverctl map normal $mod+Control Left send-layout-cmd rivertile "main-location left"
      riverctl map normal $mod+Control Right send-layout-cmd rivertile "main-location right"

      riverctl map normal $mod V toggle-float
      riverctl map normal $mod+Shift space toggle-float
      riverctl map normal $mod+Shift F toggle-fullscreen
      riverctl map normal $mod+Shift Return zoom

      riverctl map-pointer normal $mod BTN_LEFT move-view
      riverctl map-pointer normal $mod BTN_RIGHT resize-view

      # Modo resize (equivalente al "mode resize" de sway, Mod4+y)
      riverctl declare-mode resize
      riverctl map normal Mod4 Y enter-mode resize
      riverctl map resize Escape enter-mode normal
      riverctl map resize Return enter-mode normal
      riverctl map resize H resize horizontal -50
      riverctl map resize L resize horizontal 50
      riverctl map resize J resize vertical 50
      riverctl map resize K resize vertical -50

      riverctl map normal $mod F6 spawn "grim -g \"$(slurp)\" - | swappy -f -"
      riverctl map normal None Print spawn "grimshot copy area"

      ###############################################################
      # Media y brillo
      ###############################################################
      riverctl map normal None XF86MonBrightnessDown spawn "brillo -q -u 150000 -U 5"
      riverctl map normal None XF86MonBrightnessUp spawn "brillo -q -u 150000 -A 5"
      riverctl map normal None XF86AudioRaiseVolume spawn "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
      riverctl map normal None XF86AudioLowerVolume spawn "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
      riverctl map normal None XF86AudioMute spawn "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
      riverctl map normal None XF86AudioMicMute spawn "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
    '';
  };

  systemd.tmpfiles.rules = [
    "d  /home/agamotto/.config       0755 agamotto users - -"
    "d  /home/agamotto/.config/river 0755 agamotto users - -"
    "L+ /home/agamotto/.config/river/init - - - - /etc/river/init"
  ];
}
