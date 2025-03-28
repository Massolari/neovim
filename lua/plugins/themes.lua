return {
  { "projekt0n/github-nvim-theme", enabled = false },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    opts = { flavour = "latte" },
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd.colorscheme("catppuccin-latte")
    end,
    priority = 1000,
    lazy = false,
  },
  { "navarasu/onedark.nvim", opts = { style = "light" }, config = true, enabled = false },
}
