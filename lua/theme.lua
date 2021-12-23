if vim.g.colors_name == nil then
  vim.cmd('colorscheme gruvbox')
end

vim.cmd('hi link NormalFloat Normal')

vim.cmd [[highlight CmpItemMenu guifg=Normal]]

vim.cmd [[highlight DiagnosticInfo guifg=DarkCyan]]
vim.cmd [[highlight DiagnosticHint guifg=DarkGrey]]

local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end
