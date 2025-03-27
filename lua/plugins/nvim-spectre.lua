return {
  "windwp/nvim-spectre",
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = {
    {
      "<leader>es",
      function()
        require("spectre").open()
      end,
      desc = "Procurar e substituir",
    },
  },
  config = true,
}
