return {
  "akinsho/bufferline.nvim",
  event = "VeryLazy",
  opts = {
    options = {
      diagnostics = "nvim_lsp",
      diagnostics_indicator = function(_, level)
        local signs = vim.diagnostic.config().signs.text or {}

        if level == "error" then
          return signs[vim.diagnostic.severity.ERROR] or "E"
        elseif level == "warning" then
          return signs[vim.diagnostic.severity.WARN] or "W"
        end
      end,
    },
  },
}
