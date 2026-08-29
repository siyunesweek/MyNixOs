{ pkgs, ... }:
{
  # No home.stateVersion needed — that was purely a home-manager concept.
  # Your system already has its own `system.stateVersion` elsewhere, unrelated to this.
  # generates config.toml from a Nix attrset for you). Without home-manager, you
  # write the TOML yourself and place it manually — same pattern as your sway config.
  environment.etc."helix-config.toml".text = ''
    [editor.indent]
    unit = "  "
    tab-width = 2
  '';

  # Kitty: quita la confirmación al cerrar ventana con $mod+q
  environment.etc."kitty/kitty.conf".text = ''
    confirm_os_window_close 0
  '';

  
  system.activationScripts.kittyConfig.text = ''
    mkdir -p /home/agamotto/.config/kitty
    ln -sf /etc/kitty/kitty.conf /home/agamotto/.config/kitty/kitty.conf
  '';


  system.activationScripts.helixConfig.text = ''
    mkdir -p /home/agamotto/.config/helix
    ln -sf /etc/helix-config.toml /home/agamotto/.config/helix/config.toml
  '';
}
