local functions = require("functions")

return {
  "tpope/vim-fugitive",
  cmd = { "G", "Git" },
  keys = functions.prefixed_keys({
    { "ba", "<cmd>Git blame<CR>", desc = "Todos (all)" },
    { "d", "<cmd>Gdiff<CR>", desc = "Diff" },
    { "g", "<cmd>G log<CR>", desc = "Log" },
    { "w", "<cmd>Gwrite<CR>", desc = "Salvar e adicionar ao stage" },
  }, "<leader>g"),
}
