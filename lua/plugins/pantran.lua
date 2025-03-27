return {
  "potamides/pantran.nvim",
  keys = {
    {
      "<leader>ep",
      function()
        require("pantran").motion_translate()
      end,
      desc = "Traduzir com Pantran",
      expr = true,
    },
    {
      "<leader>ep",
      function()
        require("pantran").motion_translate()
      end,
      desc = "Traduzir com Pantran",
      expr = true,
      mode = "x",
    },
  },
  opts = { default_engine = "google" },
  config = true,
}
