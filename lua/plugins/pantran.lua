return {
  "potamides/pantran.nvim",
  keys = {
    {
      "<leader>ep",
      function()
        return require("pantran").motion_translate({ target = "pt" })
      end,
      desc = "Traduzir com Pantran para Português",
      expr = true,
      mode = { "n", "x" },
    },
    {
      "<leader>eP",
      function()
        return require("pantran").motion_translate()
      end,
      desc = "Traduzir com Pantran",
      expr = true,
      mode = { "n", "x" },
    },
  },
  opts = { default_engine = "google" },
  config = true,
}
