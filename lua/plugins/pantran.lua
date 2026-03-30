vim.pack.add({ "https://github.com/potamides/pantran.nvim" })

require("pantran").setup({
  default_engine = "google",
})

vim.keymap.set({ "n", "x" }, "<leader>ep", function()
  return require("pantran").motion_translate({ target = "pt" })
end, { desc = "Traduzir com Pantran para Português", expr = true })

vim.keymap.set({ "n", "x" }, "<leader>eP", function()
  return require("pantran").motion_translate()
end, { desc = "Traduzir com Pantran", expr = true })
