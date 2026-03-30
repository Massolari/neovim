local functions = require("functions")
local plugin_dir = vim.g.local_plugins_dir .. "/devto.nvim"
local source = functions.dir_exists(plugin_dir) and "file:///" .. plugin_dir
  or "https://github.com/Massolari/devto.nvim"

vim.pack.add({ source })
require("devto-nvim").setup()
