vim.pack.add({ "https://github.com/williamboman/mason.nvim" })

require("mason").setup({
  registries = { "github:mason-org/mason-registry", "github:visimp/mason-registry" },
})

vim.keymap.set("n", "<leader>et", "<cmd>Mason<CR>", { desc = "Ferramentas (Mason)" })
