vim.pack.add({ "https://github.com/folke/which-key.nvim" })
require("which-key").setup({
  preset = "helix",
  plugins = { spelling = { enabled = true }, presets = { operators = false } },
})
