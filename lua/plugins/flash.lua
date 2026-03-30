vim.pack.add({ "https://github.com/folke/flash.nvim" })

require("flash").setup({
  modes = { char = { enabled = false } },
})

vim.keymap.set({ "n", "o", "x" }, "s", function()
  require("flash").jump()
end, { desc = "Flash" })

vim.keymap.set({ "n", "o" }, "S", function()
  require("flash").treesitter()
end, { desc = "Flash Treesitter" })

vim.keymap.set("o", "r", function()
  require("flash").remote()
end, { desc = "Remote Flash" })
