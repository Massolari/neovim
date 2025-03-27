local js_formatter = { "biome", "prettierd", "prettier" }

return {
  "stevearc/conform.nvim",
  event = "BufRead",
  opts = {
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
  },
  config = function(_, opts)
    require("conform").setup(opts)
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
  end,
}
