{ config, lib, pkgs, ... }:

{
  environment.etc."sway/config".text = ''
    include /etc/sway/config.d/*

    ### Mod1 = Alt Mod4 = Super
    set $mod Mod1     
    set $left h
    set $down j
    set $up k
    set $right l
    set $term kitty
    set $menu vicinae toggle
    set $file nautilus
    set $browser firefox

    ### Input
    input "type:keyboard" {
        xkb_layout "cn"
    }

    input "type:touchpad" {
        tap enabled
        natural_scroll enabled
        dwt enabled
    }

    ### Output

    output HDMI-A-1 {
        mode 2560x1440@143.991Hz
        position 0,0
        scale 1
    }

    # 2.8K 120 Hz OLED. Set scale to 1.0 if you prefer tiny text.
    output "Samsung Display Corp. ATNA40CU05-0  Unknown" {
        mode 2880x1800@120.000Hz
        scale 1.5
        position 2560,0
        adaptive_sync on
    }
    

    # Workspace 1 = "principal": vive en el externo si está conectado,
    # si no, cae de vuelta al panel interno (mismo identificador estable).
    workspace 1 output "HDMI-A-1" "Samsung Display Corp. ATNA40CU05-0
    
    seat "*" xcursor_theme Adwaita 24

    ### Appearance
    gaps inner 8
    gaps outer 4
    default_border pixel 2

    ### SwayFX-only options
    blur enable
    blur_passes 2
    blur_radius 5
    blur_xray disable

    shadows enable
    shadows_on_csd disable
    shadow_blur_radius 20
    shadow_color #0000007F

    corner_radius 10
    smart_corner_radius enable

    default_dim_inactive 0.05
    titlebar_separator disable
    scratchpad_minimize enable

    # animation_duration_ms 200

    layer_effects "notifications" blur enable; shadows enable; corner_radius 10
    layer_effects "panel" blur enable; corner_radius 8

    ### Autostart
    exec mako
    exec dbus-update-activation-environment --all
    exec vicinae server
    exec noctalia
    exec dbus-update-activation-environment --systemd --all
    exec_always gnome-keyring-daemon --start --components=pkcs11,secrets,ssh
    exec fcitx5 -d
    exec handy


    ### Keybindings
    bindsym $mod+Return exec $term
    bindsym $mod+r exec $menu
    bindsym $mod+q kill
    bindsym $mod+Shift+c reload
    bindsym $mod+Control+m exec swaymsg exit
    floating_modifier $mod normal
    tiling_drag enable

    bindsym $mod+$left focus left
    bindsym $mod+$down focus down
    bindsym $mod+$up focus up
    bindsym $mod+$right focus right
    bindsym $mod+Left focus left
    bindsym $mod+Down focus down
    bindsym $mod+Up focus up
    bindsym $mod+Right focus right
    bindsym $mod+Shift+$left move left
    bindsym $mod+Shift+$down move down
    bindsym $mod+Shift+$up move up
    bindsym $mod+Shift+$right move right
    bindsym $mod+Shift+Left move left
    bindsym $mod+Shift+Down move down
    bindsym $mod+Shift+Up move up
    bindsym $mod+Shift+Right move right

    bindsym $mod+1 workspace number 1
    bindsym $mod+2 workspace number 2
    bindsym $mod+3 workspace number 3
    bindsym $mod+4 workspace number 4
    bindsym $mod+5 workspace number 5
    bindsym $mod+6 workspace number 6
    bindsym $mod+7 workspace number 7
    bindsym $mod+8 workspace number 8
    bindsym $mod+9 workspace number 9
    bindsym $mod+0 workspace number 10

    bindsym $mod+Shift+1 move container to workspace number 1
    bindsym $mod+Shift+2 move container to workspace number 2
    bindsym $mod+Shift+3 move container to workspace number 3
    bindsym $mod+Shift+4 move container to workspace number 4
    bindsym $mod+Shift+5 move container to workspace number 5
    bindsym $mod+Shift+6 move container to workspace number 6
    bindsym $mod+Shift+7 move container to workspace number 7
    bindsym $mod+Shift+8 move container to workspace number 8
    bindsym $mod+Shift+9 move container to workspace number 9
    bindsym $mod+Shift+0 move container to workspace number 10

    # bindsym $mod+b splith
    bindsym $mod+v floating toggle
    # bindsym $mod+Shift+v splitv
    bindsym $mod+s layout stacking
    bindsym $mod+w layout tabbed
    bindsym $mod+e layout toggle split
    bindsym $mod+Shift+f fullscreen
    bindsym $mod+Shift+space floating toggle
    bindsym $mod+space focus mode_toggle
    bindsym $mod+a focus parent
    bindsym $mod+Shift+r exec "pkill vicinae; vicinae server &"

    bindsym $mod+Tab workspace next
    bindsym $mod+Shift+Tab workspace prev

    bindsym $mod+Shift+minus move scratchpad
    bindsym $mod+minus scratchpad show
    bindsym Mod1+F6 exec grim -g "$(slurp)" - | swappy -f -

    bindsym $mod+f exec $file
    bindsym $mod+b exec $browser
    bindsym $mod+comma exec pkill -USR2 -n handy


    mode "resize" {
        bindsym $left resize shrink width 10px
        bindsym $down resize grow height 10px
        bindsym $up resize shrink height 10px
        bindsym $right resize grow width 10px
        bindsym Return mode "default"
        bindsym Escape mode "default"
    }
    # SUPER no es un nombre válido de modificador; se escribe Mod4.
    bindsym Mod4+y mode "resize"

    ### Media and brightness
    bindsym XF86MonBrightnessDown exec brillo -q -u 150000 -U 1; exec pkill -USR1 -f sway-status
    bindsym XF86MonBrightnessUp exec brillo -q -u 150000 -A 1; exec pkill -USR1 -f sway-status
    bindsym XF86AudioRaiseVolume exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+; exec pkill -USR1 -f sway-status
    bindsym XF86AudioLowerVolume exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-; exec pkill -USR1 -f sway-status
    bindsym XF86AudioMute exec wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle; exec pkill -USR1 -f sway-status
    bindsym XF86AudioMicMute exec wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle; exec pkill -USR1 -f sway-status
    bindsym Print exec grimshot copy area

  '';

  # Para que se copie en .config/sway
  systemd.tmpfiles.rules = [
    "d  /home/agamotto/.config       0755 agamotto users - -"
    "d  /home/agamotto/.config/sway  0755 agamotto users - -"
    "L+ /home/agamotto/.config/sway/config - - - - /etc/sway/config"
  ];
}
