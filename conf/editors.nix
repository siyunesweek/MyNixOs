{ pkgs, ... }:

{
  home-manager.users.agamotto = { pkgs, ... }: {
    home.stateVersion = "25.11";

    programs.neovim = {
      enable = true;
      extraLuaConfig = ''
        vim.opt.tabstop = 2
        vim.opt.shiftwidth = 2
        vim.opt.expandtab = true
      '';
    };

    programs.helix = {
      enable = true;
      settings = {
        editor.indent = {
          unit = "  ";
          tab-width = 2;
        };
      };
    };
  };
}
