return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "stylua",
        "lua-language-server",
        "bash-language-server",
        "shfmt",
        "typescript-language-server",
        "biome",
        "html-lsp",
        "css-lsp",
        "pyright",
        "ruff",
      },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        css = { "biome" },
        html = { "biome" },
        javascript = { "biome" },
        typescript = { "biome" },
        jsx = { "biome" },
        tsx = { "biome" },
        sh = { "shfmt" },
        bash = { "shfmt" },
        zsh = { "shfmt" },
        python = {}, -- use ruff as fallback,
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        bashls = {
          filetypes = { "sh", "zsh" },
        },
      },
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    opts = {
      options = {
        theme = "catppuccin",
        section_separators = "",
        component_separators = "",
      },
      sections = {
        lualine_z = {
          function()
            local bufnr = vim.api.nvim_get_current_buf()
            local clients = vim.lsp.get_clients({ bufnr = bufnr })
            if #clients == 0 then
              return ""
            end

            local client_names = {}
            for _, client in pairs(clients) do
              table.insert(client_names, client.name)
            end
            return "\u{f085} " .. table.concat(client_names, "|")
          end,
        },
      },
    },
  },
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        sources = {
          explorer = {
            layout = { layout = { position = "right" } },
          },
        },
      },
    },
  },
}
