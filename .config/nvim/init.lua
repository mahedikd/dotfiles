-- ========================================================================== --
-- 1. BOOTSTRAP LAZY.NVIM
-- ========================================================================== --
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- ========================================================================== --
-- 2. GLOBAL SETTINGS & OPTIONS
-- ========================================================================== --
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local opt = vim.opt
opt.number = true           -- Show line numbers
opt.relativenumber = true   -- Relative line numbers
opt.termguicolors = true    -- True color support
opt.tabstop = 4             -- Number of spaces tabs count for
opt.shiftwidth = 4          -- Size of an indent
opt.expandtab = true        -- Use spaces instead of tabs
opt.smartindent = true      -- Insert indents automatically
opt.clipboard = "unnamedplus" -- Sync with system clipboard
opt.ignorecase = true       -- Ignore case in search patterns
opt.smartcase = true        -- Unless \C or capital in search
opt.cursorline = true       -- Highlight the current line
opt.scrolloff = 10          -- Lines of context
opt.mouse = "a"             -- Enable mouse support

-- ========================================================================== --
-- 3. PLUGINS (lazy.nvim)
-- ========================================================================== --
require("lazy").setup({
  -- Spacebar Menu (which-key)
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "classic",
      delay = 300,
    },
  },

  -- Color Scheme
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("catppuccin")
    end,
  },

  -- Status Line
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        section_separators = "",
        component_separators = "",
      },
    },
  },

  -- Tmux Navigation
  {
    "alexghergh/nvim-tmux-navigation",
    config = function()
      local nvim_tmux_nav = require("nvim-tmux-navigation")
      vim.keymap.set("n", "<C-h>", nvim_tmux_nav.NvimTmuxNavigateLeft)
      vim.keymap.set("n", "<C-j>", nvim_tmux_nav.NvimTmuxNavigateDown)
      vim.keymap.set("n", "<C-k>", nvim_tmux_nav.NvimTmuxNavigateUp)
      vim.keymap.set("n", "<C-l>", nvim_tmux_nav.NvimTmuxNavigateRight)
    end,
  },

  -- Fast Escape
  { "max397574/better-escape.nvim", opts = {} },

  -- Simple commenting (gcc / gc)
  { "tpope/vim-commentary" },
})

-- ========================================================================== --
-- 4. KEYMAPS (Minimal Text Editor Set)
-- ========================================================================== --
local key = vim.keymap

-- General
key.set("n", "<leader>w", "<cmd>w<cr>", { desc = "Save File" })
key.set("n", "<leader>q", "<cmd>confirm q<cr>", { desc = "Quit" })
key.set("n", "<leader>nh", "<cmd>nohlsearch<cr>", { desc = "Clear Highlights" })

-- Buffer Management
key.set("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
key.set("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next Buffer" })
key.set("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete Buffer" })

-- ========================================================================== --
-- 5. AUTOCOMMANDS
-- ========================================================================== --
-- Auto-change directory to current file (from your screenshot)
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "*",
  command = "silent! lcd %:p:h",
})

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
})
