{ pkgs, ... }:
{
  # No home.stateVersion needed — that was purely a home-manager concept.
  # Your system already has its own `system.stateVersion` elsewhere, unrelated to this.

  programs.neovim = {
    enable = true;
    # NixOS's neovim module doesn't have `extraLuaConfig` directly like home-manager's does.
    # The equivalent is `configure.customRC`, wrapping your Lua in a `lua << EOF ... EOF` block:
    configure.customRC = ''
      lua << EOF
      vim.opt.tabstop = 2
      vim.opt.shiftwidth = 2
      vim.opt.expandtab = true
      EOF
    '';
  };

  # NixOS has no `programs.helix` module at all (that's home-manager-only, which
  # generates config.toml from a Nix attrset for you). Without home-manager, you
  # write the TOML yourself and place it manually — same pattern as your sway config.
  environment.etc."helix-config.toml".text = ''
    [editor.indent]
    unit = "  "
    tab-width = 2
  '';

  system.activationScripts.helixConfig.text = ''
    mkdir -p /home/agamotto/.config/helix
    ln -sf /etc/helix-config.toml /home/agamotto/.config/helix/config.toml
  '';
}
