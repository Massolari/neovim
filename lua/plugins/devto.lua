local functions = require("functions")
local plugin_dir = vim.g.local_plugins_dir .. "/devto.nvim"

if functions.dir_exists(plugin_dir) then
  vim.cmd.packadd("devto.nvim")
else
  vim.pack.add({ "https://github.com/Massolari/devto.nvim" })
end
require("devto-nvim").setup()
