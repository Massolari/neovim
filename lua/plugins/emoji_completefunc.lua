local functions = require("functions")
local plugin_dir = vim.g.local_plugins_dir .. "/emoji-completefunc"

if functions.dir_exists(plugin_dir) then
  vim.cmd.packadd("emoji-completefunc")
else
  vim.pack.add({ "https://github.com/Massolari/emoji-completefunc" })
end

vim.opt.complete:append({ "Fv:lua.emoji_completefunc" })
