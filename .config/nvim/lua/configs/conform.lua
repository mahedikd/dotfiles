local options = {
  formatters_by_ft = {
    lua = { "stylua" },

    css = { "prettier" },
    html = { "prettier" },
    javascript = { "prettier" },
    javascriptreact = { "prettier" },
    typescript = { "prettier" },
    typescriptreact = { "prettier" },
    jsx = { "prettier" },
    tsx = { "prettier" },

    python = { "black" },
    -- vue = "vue",
    --     css = "css",
    --     scss = "scss",
    --     less = "less",
    --     html = "html",
    --     json = "json",
    --     jsonc = "json",
    --     yaml = "yaml",
    --     markdown = "markdown",
  },

  format_on_save = {
    timeout_ms = 500,
    lsp_fallback = true,
  },
}

return options
