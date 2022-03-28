if vim.g.colors_name == nil then
  vim.cmd('colorscheme gruvbox')
  -- vim.cmd('colorscheme xcodelighthc')
end

vim.cmd('hi link NormalFloat Normal')

vim.cmd('hi link CocSymbolLine CursorLine')
-- vim.cmd('hi! clear CocSymbolLine')
-- vim.cmd('hi! CocSymbolLine NONE')

local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end
