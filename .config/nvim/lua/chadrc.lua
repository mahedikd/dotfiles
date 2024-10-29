-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v2.5/lua/nvconfig.lua
-- Please read that file to know all available options :(

---@type ChadrcConfig
local M = {}

M.base46 = {
  theme = "catppuccin",

  -- hl_override = {
  -- 	Comment = { italic = true },
  -- 	["@comment"] = { italic = true },
  -- },

}

M.mason = {
  pkgs = {
    -- formatter --
    "stylua",
    "prettier",
    "black",
    -- lsp servers --
    "lua-language-server",
    "html-lsp",
    "css-lsp",
    "typescript-language-server", -- Updated from ts_ls
    "pyright",
  },
}

M.nvdash = {
  load_on_startup = true,
}

M.plugins = {
  require("nvim-tree").setup({
    view = {
      side = "right"
    }
  })
}


return M
