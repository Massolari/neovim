local functions = require("functions")
local plugin_dir = vim.g.local_plugins_dir .. "/nvim-snippets"

--- @type LazyPluginSpec
return {
  "garymjr/nvim-snippets",
  lazy = false,
  dependencies = { "rafamadriz/friendly-snippets" },
  opts = {
    friendly_snippets = true,
    create_cmp_source = false,
    create_native_completion = vim.fn.has("nvim-0.12") == 1,
  },
  dir = functions.dir_exists(plugin_dir) and plugin_dir or nil,
  config = function(_, opts)
    require("snippets").setup(opts)
    if vim.fn.has("nvim-0.12") == 1 then
      vim.opt.complete:append({ "Fv:lua.nvim_snippets_complete" })
    end
  end,
}
