return {
  "kevinhwang91/nvim-ufo",
  enabled = false,
  dependencies = { "kevinhwang91/promise-async" },
  event = "BufReadPost",
  init = function()
    vim.o.fillchars = "eob: ,fold: ,foldopen:,foldsep: ,foldclose:"
    vim.o.foldcolumn = "1"
    vim.o.foldlevel = 99
    vim.o.foldlevelstart = 99
    vim.o.foldenable = true
  end,
  keys = {
    {
      "zR",
      function()
        require("ufo").openAllFolds()
      end,
    },
    {
      "zM",
      function()
        require("ufo").closeAllFolds()
      end,
    },
    {
      "zr",
      function()
        require("ufo").openFoldsExceptKinds()
      end,
    },
    {
      "zm",
      function()
        require("ufo").closeFoldsWith()
      end,
    },
  },
  opts = {
    provider_selector = function()
      return { "treesitter", "indent" }
    end,
  },
  config = true,
}
