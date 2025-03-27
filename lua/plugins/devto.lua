-- local functions = require("functions")

-- local plugin_dir = (vim.g.local_plugins_dir .. "/devto.nvim")

return {
  "Massolari/devto.nvim",
  -- cond = functions.dir_exists(plugin_dir),
  -- dir = plugin_dir,
  config = true,
  cmd = "Devto",
}
