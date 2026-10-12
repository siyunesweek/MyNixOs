{ config, pkgs, ... }:

{
  programs.niri.enable = true;

  # niri lanza xwayland-satellite bajo demanda para apps X11
  environment.systemPackages = [ pkgs.xwayland-satellite ];

  environment.etc."niri/config.kdl".text = ''
    ///////////////////////////////////////////////////////////////
    // Input
    ///////////////////////////////////////////////////////////////
    input {
        keyboard {
            xkb {
                layout "cn"
            }
        }

        touchpad {
            tap
            natural-scroll
            dwt
        }
    }

    ///////////////////////////////////////////////////////////////
    // Outputs
    ///////////////////////////////////////////////////////////////
    output "HDMI-A-1" {
        mode "2560x1440@143.991"
        scale 0.75
        position x=0 y=0
    }

    output "Samsung Display Corp. ATNA40CU05-0 Unknown" {
        mode "2880x1800@120.000"
        scale 1
        position x=2560 y=0
        variable-refresh-rate
    }

    workspace "principal" {
        open-on-output "HDMI-A-1"
    }

    ///////////////////////////////////////////////////////////////
    // Apariencia
    ///////////////////////////////////////////////////////////////
    prefer-no-csd

    cursor {
        xcursor-theme "Adwaita"
        xcursor-size 24
    }

    hotkey-overlay {
        skip-at-startup
    }

    layout {
        gaps 8

        struts {
            left 4
            right 4
            top 4
            bottom 4
        }

        focus-ring {
            off
        }
        border {
            width 2
            active-color "#4c7899"
            inactive-color "#333333"
        }

        shadow {
            on
            softness 20
            spread 0
            offset x=0 y=0
            color "#0000007F"
        }

        default-column-width { proportion 0.5; }
    }

    blur {
        passes 2
        offset 3
    }

    window-rule {
        geometry-corner-radius 10
        clip-to-geometry true

        background-effect {
            blur true
        }
    }

    layer-rule {
        match namespace="notifications"
        geometry-corner-radius 10
        shadow {
            on
        }
        background-effect {
            blur true
        }
    }

    layer-rule {
        match namespace="panel"
        geometry-corner-radius 8
        background-effect {
            blur true
        }
    }

    ///////////////////////////////////////////////////////////////
    // Autostart
    ///////////////////////////////////////////////////////////////
    spawn-at-startup "mako"
    spawn-at-startup "dbus-update-activation-environment" "--systemd" "--all"
    spawn-at-startup "vicinae" "server"
    spawn-at-startup "noctalia"
    spawn-at-startup "gnome-keyring-daemon" "--start" "--components=pkcs11,secrets,ssh"
    spawn-at-startup "fcitx5" "-d"
    spawn-at-startup "handy"

    ///////////////////////////////////////////////////////////////
    // Keybindings
    ///////////////////////////////////////////////////////////////
    binds {
        // Apps
        Alt+Return { spawn "kitty"; }
        Alt+R      { spawn "vicinae" "toggle"; }
        Alt+F      { spawn "nautilus"; }
        Alt+B      { spawn "firefox"; }
        Alt+Comma  { spawn "pkill" "-USR2" "-n" "handy"; }
        Alt+Shift+R { spawn "sh" "-c" "pkill vicinae; vicinae server &"; }

        Alt+Q { close-window; }
        Alt+Ctrl+M { quit; }

        Alt+H     { focus-column-left; }
        Alt+J     { focus-window-down; }
        Alt+K     { focus-window-up; }
        Alt+L     { focus-column-right; }
        Alt+Left  { focus-column-left; }
        Alt+Down  { focus-window-down; }
        Alt+Up    { focus-window-up; }
        Alt+Right { focus-column-right; }

        Alt+Shift+H     { move-column-left; }
        Alt+Shift+J     { move-window-down; }
        Alt+Shift+K     { move-window-up; }
        Alt+Shift+L     { move-column-right; }
        Alt+Shift+Left  { move-column-left; }
        Alt+Shift+Down  { move-window-down; }
        Alt+Shift+Up    { move-window-up; }
        Alt+Shift+Right { move-column-right; }

        Alt+1 { focus-workspace 1; }
        Alt+2 { focus-workspace 2; }
        Alt+3 { focus-workspace 3; }
        Alt+4 { focus-workspace 4; }
        Alt+5 { focus-workspace 5; }
        Alt+6 { focus-workspace 6; }
        Alt+7 { focus-workspace 7; }
        Alt+8 { focus-workspace 8; }
        Alt+9 { focus-workspace 9; }
        Alt+0 { focus-workspace 10; }

        Alt+Shift+1 { move-window-to-workspace 1; }
        Alt+Shift+2 { move-window-to-workspace 2; }
        Alt+Shift+3 { move-window-to-workspace 3; }
        Alt+Shift+4 { move-window-to-workspace 4; }
        Alt+Shift+5 { move-window-to-workspace 5; }
        Alt+Shift+6 { move-window-to-workspace 6; }
        Alt+Shift+7 { move-window-to-workspace 7; }
        Alt+Shift+8 { move-window-to-workspace 8; }
        Alt+Shift+9 { move-window-to-workspace 9; }
        Alt+Shift+0 { move-window-to-workspace 10; }

        Alt+Tab       { focus-workspace-down; }
        Alt+Shift+Tab { focus-workspace-up; }

        Alt+V           { toggle-window-floating; }
        Alt+Shift+Space { toggle-window-floating; }
        Alt+Space       { switch-focus-between-floating-and-tiling; }
        Alt+Shift+F     { fullscreen-window; }

        Alt+W { toggle-column-tabbed-display; }  // layout tabbed
        Alt+E { switch-preset-column-width; }    // en sway: toggle split
        Alt+S { maximize-column; }               // en sway: layout stacking

        Alt+BracketLeft  { consume-or-expel-window-left; }
        Alt+BracketRight { consume-or-expel-window-right; }
        Alt+C { center-column; }
        Alt+O { toggle-overview; }

        // Resize: niri no tiene modos, así que en lugar de Super+Y -> resize
        // usa Alt+Ctrl+hjkl directamente.
        Alt+Ctrl+H { set-column-width "-10"; }
        Alt+Ctrl+L { set-column-width "+10"; }
        Alt+Ctrl+J { set-window-height "+10"; }
        Alt+Ctrl+K { set-window-height "-10"; }

        Alt+F6 { spawn "sh" "-c" "grim -g \"$(slurp)\" - | swappy -f -"; }
        Print  { spawn "grimshot" "copy" "area"; }

        XF86MonBrightnessDown allow-when-locked=true { spawn "brillo" "-q" "-u" "150000" "-U" "1"; }
        XF86MonBrightnessUp   allow-when-locked=true { spawn "brillo" "-q" "-u" "150000" "-A" "1"; }
        XF86AudioRaiseVolume  allow-when-locked=true { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%+"; }
        XF86AudioLowerVolume  allow-when-locked=true { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%-"; }
        XF86AudioMute         allow-when-locked=true { spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"; }
        XF86AudioMicMute      allow-when-locked=true { spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle"; }
    }
  '';

  systemd.tmpfiles.rules = [
    "d  /home/agamotto/.config/niri            0755 agamotto users - -"
    "L+ /home/agamotto/.config/niri/config.kdl -    -        -     - /etc/niri/config.kdl"
  ];
}
