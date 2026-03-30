vim.pack.add({ "https://github.com/tpope/vim-fugitive" })

vim.keymap.set("n", "<leader>gba", "<cmd>Git blame<CR>", { desc = "Todos (all)" })
vim.keymap.set("n", "<leader>gd", "<cmd>Gdiff<CR>", { desc = "Diff" })
vim.keymap.set("n", "<leader>gg", "<cmd>G log<CR>", { desc = "Log" })
vim.keymap.set("n", "<leader>gw", "<cmd>Gwrite<CR>", { desc = "Salvar e adicionar ao stage" })
