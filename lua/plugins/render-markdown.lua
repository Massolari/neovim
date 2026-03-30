require("plugins.nvim-web-devicons")
require("plugins.treesitter")

vim.pack.add({ "https://github.com/MeanderingProgrammer/render-markdown.nvim" })

require("render-markdown").setup({
  patterns = { markdown = { disable = false } },
})
