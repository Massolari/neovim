require("plugins.fzf-lua")

vim.pack.add({ "https://github.com/pwntester/octo.nvim" })

require("octo").setup({
  enable_builtin = true,
  default_delete_branch = true,
  picker = "fzf-lua",
})

vim.keymap.set("n", "<leader>gic", "<cmd>Octo issue create<CR>", { desc = "Criar" })
vim.keymap.set("n", "<leader>gil", "<cmd>Octo issue list<CR>", { desc = "Listar" })
vim.keymap.set("n", "<leader>go", "<cmd>Octo actions<CR>", { desc = "Octo (ações do GitHub)" })
vim.keymap.set("n", "<leader>guc", "<cmd>Octo pr create<CR>", { desc = "Criar" })
vim.keymap.set("n", "<leader>gul", "<cmd>Octo pr list<CR>", { desc = "Listar" })
