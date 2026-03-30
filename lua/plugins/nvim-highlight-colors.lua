vim.pack.add({ "https://github.com/brenoprata10/nvim-highlight-colors" })

require("nvim-highlight-colors").setup({
  enable_tailwind = true,
  render = "virtual",
})

vim.keymap.set("n", "<leader>eo", "<cmd>HighlightColors Toggle<cr>", { desc = "Alternar visualização de cores" })
