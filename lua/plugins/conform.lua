vim.pack.add({ "https://github.com/stevearc/conform.nvim" })
local js_formatter = { "biome", "prettierd", "prettier" }

require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua" },
    elm = { "elm_format" },
    fennel = { "fnlfmt" },
    gleam = { "gleam" },
    go = { "gofmt" },
    jsx = js_formatter,
    javascript = js_formatter,
    typescript = js_formatter,
    typescriptreact = js_formatter,
    tsx = js_formatter,
  },
  default_format_opts = { stop_after_first = true },
  log_level = vim.log.levels.INFO,
  format_on_save = { timeout_ms = 10000, lsp_fallback = true },
})

vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
