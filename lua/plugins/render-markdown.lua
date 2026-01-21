--- @type LazyPluginSpec
return {
  "MeanderingProgrammer/render-markdown.nvim",
  opts = {
    patterns = { markdown = { disable = false } },
  },
  ft = "markdown",
  dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
}
