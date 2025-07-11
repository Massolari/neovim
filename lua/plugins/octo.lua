local functions = require("functions")

--- @type LazyPluginSpec
return {
  "pwntester/octo.nvim",
  config = true,
  cmd = "Octo",
  opts = { picker = "fzf-lua" },
  keys = functions.prefixed_keys({
    { "ic", "<cmd>Octo issue create<CR>", desc = "Criar" },
    { "il", "<cmd>Octo issue list<CR>", desc = "Listar" },
    { "o", "<cmd>Octo actions<CR>", desc = "Octo (a\195\167\195\181es do GitHub)" },
    { "uc", "<cmd>Octo pr create<CR>", desc = "Criar" },
    { "ul", "<cmd>Octo pr list<CR>", desc = "Listar" },
  }, "<leader>g"),
}
