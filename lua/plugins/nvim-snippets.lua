local functions = require("functions")
local plugin_dir = vim.g.local_plugins_dir .. "/nvim-snippets"

--- @type LazyPluginSpec
return {
  "Massolari/nvim-snippets",
  lazy = false,
  dependencies = { "rafamadriz/friendly-snippets", "onsails/lspkind.nvim" },
  dir = functions.dir_exists(plugin_dir) and plugin_dir or nil,
  config = function()
    require("snippets").setup({
      friendly_snippets = true,
      create_cmp_source = false,
      create_native_completion = true,
      native_completion_kind = require("lspkind").presets.codicons["Snippet"],
    })
    vim.opt.complete:append({ "Fv:lua.nvim_snippets_complete" })
  end,
}
