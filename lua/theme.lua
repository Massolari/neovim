local constants = require("constants")

local signs = {
  Error = constants.diagnostic_icon.error,
  Warn = constants.diagnostic_icon.warning,
  Info = constants.diagnostic_icon.info,
  Hint = constants.diagnostic_icon.int,
}

for type, icon in pairs(signs) do
  local hl = ("DiagnosticSign" .. type)
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

vim.api.nvim_set_hl(0, "NormalFloat", { link = "Normal" })
