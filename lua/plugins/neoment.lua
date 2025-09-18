return {
  "Massolari/neoment.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  init = function()
    vim.g.neoment = {
      save_session = true,
    }
  end,
}
