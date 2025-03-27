local constants = require("constants")

return {
  "akinsho/bufferline.nvim",
  event = "VeryLazy",
  opts = {
    options = {
      diagnostics = "nvim_lsp",
      diagnostics_indicator = function(_, level)
        if level == "error" then
          return constants.diagnostic_icon.error
        elseif level == "warning" then
          return constants.diagnostic_icon.warning
        end
      end,
    },
  },
}
