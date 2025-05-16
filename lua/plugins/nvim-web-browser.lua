local functions = require("functions")

local plugin_dir = vim.g.local_plugins_dir .. "/nvim-web-browser"

--- @type LazyPluginSpec
return {
  "Massolari/nvim-web-browser",
  cond = functions.dir_exists(plugin_dir),
  enabled = false,
  dir = plugin_dir,
  dependencies = "nvim-lua/plenary.nvim",
  config = true,
}
