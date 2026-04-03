local functions = require("functions")
local plugin_dir = vim.g.local_plugins_dir .. "/nvim-snippets"

require("plugins.lspkind")
vim.pack.add({ "https://github.com/rafamadriz/friendly-snippets" })

if functions.dir_exists(plugin_dir) then
  vim.cmd.packadd("nvim-snippets")
else
  vim.pack.add({ "https://github.com/Massolari/nvim-snippets" })
end

require("snippets").setup({
  friendly_snippets = true,
  create_cmp_source = false,
  create_native_completion = true,
  native_completion_kind = require("lspkind").presets.codicons["Snippet"],
})
vim.opt.complete:append({ "Fv:lua.nvim_snippets_complete" })
