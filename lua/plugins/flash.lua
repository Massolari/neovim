return {
  "folke/flash.nvim",
  event = "VeryLazy",
  opts = { modes = { char = { enabled = false } } },
  keys = {
    {
      "s",
      function()
        require("flash").jump()
      end,
      mode = { "n", "o", "x" },
      desc = "Flash",
    },
    {
      "S",
      function()
        require("flash").treesitter()
      end,
      mode = { "n", "o" },
      desc = "Flash Treesitter",
    },
    {
      "r",
      function()
        require("flash").remote()
      end,
      mode = "o",
      desc = "Remote Flash",
    },
  },
}
