-- vim.pack.add({ "https://github.com/projekt0n/github-nvim-theme" })
-- vim.cmd.colorscheme("github_light")

-- vim.pack.add({ { src = "https://github.com/catppuccin/nvim", name = "catppuccin" } })
-- require("catppuccin").setup({ flavour = "latte" })
-- vim.cmd.colorscheme("catppuccin-latte")
-- vim.api.nvim_set_hl(0, "FloatBorder", { link = "@text.title" })

-- vim.pack.add({ "https://github.com/navarasu/onedark.nvim" })
-- require("onedark").setup({ style = "light" })

vim.pack.add({
  "https://github.com/rktjmp/lush.nvim",
  "https://github.com/zenbones-theme/zenbones.nvim",
})
vim.g.tokyobones_lightness = "bright"
vim.cmd.colorscheme("tokyobones")
