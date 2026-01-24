return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
  -- 1. Tree-sitter for Go syntax
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        -- Go
        "go",
        "gomod",
        "gowork",
        "gosum",
        -- Web Dev
        "typescript",
        "javascript",
        "tsx",
        "html",
        "css",
        "tailwind",
        -- Systems & Config
        "python",
        "bash",
        "lua",
        "vim",
        "vimdoc",
        "dockerfile",
        "yaml",
        "json",
        "markdown",
        "markdown_inline",
      },
    },
  },
  -- 2. Mason for Go Binaries
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "stylua",
        "lua-language-server",
        "bash-language-server",
        "shfmt",
        "typescript-language-server",
        "prettierd",
        "eslint_d",
        "html-lsp",
        "css-lsp",
        "pyright",
        "ruff",
        -- Go Tools from LazyVim Extra
        "goimports",
        "gofumpt",
        "gomodifytags",
        "impl",
        "golangci-lint",
        "delve",
      },
    },
  },
  -- 3. LSP Config with gopls workaround and settings
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        bashls = { filetypes = { "sh", "zsh" } },
        gopls = {
          settings = {
            gopls = {
              gofumpt = true,
              codelenses = {
                gc_details = false,
                generate = true,
                regenerate_cgo = true,
                run_govulncheck = true,
                test = true,
                tidy = true,
                upgrade_dependency = true,
                vendor = true,
              },
              hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
              },
              analyses = {
                nilness = true,
                unusedparams = true,
                unusedwrite = true,
                useany = true,
              },
              usePlaceholders = true,
              completeUnimported = true,
              staticcheck = true,
              directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
              semanticTokens = true,
            },
          },
        },
      },
      setup = {
        gopls = function(_, opts)
          -- Fix for gopls semantic tokens
          require("lazyvim.util").lsp.on_attach(function(client, _)
            if not client.server_capabilities.semanticTokensProvider then
              local semantic = client.config.capabilities.textDocument.semanticTokens
              client.server_capabilities.semanticTokensProvider = {
                full = true,
                legend = {
                  tokenTypes = semantic.tokenTypes,
                  tokenModifiers = semantic.tokenModifiers,
                },
                range = true,
              }
            end
          end, "gopls")
        end,
      },
    },
  },
  -- 4. Formatting with Conform
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        css = { "prettierd" },
        html = { "prettierd" },
        javascript = { "prettierd", "eslint_d" },
        typescript = { "prettierd", "eslint_d" },
        sh = { "shfmt" },
        python = {},
        go = { "goimports", "gofumpt" },
      },
    },
  },
  -- 5. Debugging and Testing
  -- { "leoluz/nvim-dap-go", opts = {} },
  -- {
  --   "nvim-neotest/neotest",
  --   optional = true,
  --   dependencies = { "fredrikaverpil/neotest-golang" },
  --   opts = {
  --     adapters = {
  --       ["neotest-golang"] = {
  --         dap_go_enabled = true,
  --       },
  --     },
  --   },
  -- },
  -- 6. Custom Lualine (Preserved)
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
            return "󰄭 " .. table.concat(client_names, "|")
          end,
        },
      },
    },
  },
  -- 7. Snacks Explorer (Preserved)
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        hidden = true,
        ignored = true,
        sources = {
          explorer = {
            layout = { layout = { position = "right" } },
          },
        },
      },
    },
  },
}
