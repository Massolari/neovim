--- @type LazySpec[]
return {
  {
    "projekt0n/github-nvim-theme",
    config = function()
      -- vim.cmd.colorscheme("github_light")
    end,
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    opts = { flavour = "latte" },
    -- config = function(_, opts)
    --   require("catppuccin").setup(opts)
    --   vim.cmd.colorscheme("catppuccin-latte")
    --   vim.api.nvim_set_hl(0, "FloatBorder", { link = "@text.title" })
    -- end,
    priority = 1000,
    lazy = false,
  },
  {
    "navarasu/onedark.nvim",
    opts = { style = "light" },
    config = true,
  },
  {
    "zenbones-theme/zenbones.nvim",
    -- Optionally install Lush. Allows for more configuration or extending the colorscheme
    -- If you don't want to install lush, make sure to set g:zenbones_compat = 1
    -- In Vim, compat mode is turned on as Lush only works in Neovim.
    dependencies = "rktjmp/lush.nvim",
    lazy = false,
    priority = 1000,
    init = function()
      vim.g.tokyobones_lightness = "bright"
    end,
    -- you can set set configuration options here
    config = function()
      vim.cmd.colorscheme("tokyobones")
    end,
  },
}
