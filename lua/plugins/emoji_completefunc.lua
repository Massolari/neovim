local functions = require("functions")
local plugin_dir = vim.g.local_plugins_dir .. "/emoji-completefunc"
local source = functions.dir_exists(plugin_dir) and "file:///" .. plugin_dir
  or "https://github.com/Massolari/emoji-completefunc.nvim"

vim.pack.add({ source })

vim.opt.complete:append({ "Fv:lua.emoji_completefunc" })
