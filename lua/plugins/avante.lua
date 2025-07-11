--- @type LazyPluginSpec
return {
  "yetone/avante.nvim",
  event = "BufRead",
  opts = { provider = "copilot", copilot = { model = "claude-3.7-sonnet" } },
  build = "make",
  dependencies = {
    "stevearc/dressing.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "hrsh7th/nvim-cmp",
    "ibhagwan/fzf-lua",
    "nvim-tree/nvim-web-devicons",
    {
      "MeanderingProgrammer/render-markdown.nvim",
      opts = { file_types = { "markdown", "Avante" } },
      ft = { "markdown", "Avante" },
    },
  },
  version = false,
}
