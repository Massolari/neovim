vim.pack.add({ "https://github.com/nvim-tree/nvim-web-devicons" })

require("nvim-web-devicons").setup({
  override = { gleam = { icon = " ", color = "#ffaff3", cterm_color = "219", name = "Gleam" } },
})
