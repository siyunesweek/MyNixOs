{ config, pkgs, ... }:

let
  user = "agamotto";
  home = "/home/${user}";

  nvimInitLua = pkgs.writeText "init.lua" ''
    vim.opt.tabstop = 2
    vim.opt.shiftwidth = 2
    vim.opt.expandtab = true

    vim.g.mapleader = " "

    -- Portapapeles del sistema
    vim.keymap.set({ "n", "v" }, "<leader>y", '"+y', { desc = "Copiar al portapapeles del sistema" })
    vim.keymap.set({ "n", "v" }, "<leader>p", '"+p', { desc = "Pegar del portapapeles del sistema" })

    -- Plantilla makeDesktopItem, solo en archivos .nix
    local function insert_desktop_item()
      local lines = {
        "(pkgs.makeDesktopItem {",
        "  name = \"\";",
        "  desktopName = \"\";",
        "  exec = \"\";",
        "  icon = \"\";",
        "  comment = \"\";",
        "  categories = [ \"Development\" ];",
        "  terminal = false;",
        "})",
      }
      local row = vim.api.nvim_win_get_cursor(0)[1]
      vim.api.nvim_buf_set_lines(0, row, row, false, lines)
      vim.api.nvim_win_set_cursor(0, { row + 2, 10 })
    end

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "nix",
      callback = function()
        vim.keymap.set("n", "<leader>di", insert_desktop_item,
          { buffer = true, desc = "Insertar plantilla makeDesktopItem" })
      end,
    })
  '';
in
{
  programs.neovim.enable = true;

  system.activationScripts.neovimConfig = {
    deps = [ "users" ];
    text = ''
      mkdir -p ${home}/.config/nvim
      ln -sf ${nvimInitLua} ${home}/.config/nvim/init.lua
      chown -h ${user}:users ${home}/.config/nvim/init.lua
    '';
  };
}
