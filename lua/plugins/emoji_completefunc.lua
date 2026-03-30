local functions = require("functions")

local plugin_dir = vim.g.local_plugins_dir .. "/emoji-completefunc"

--- @type LazyPluginSpec
return {
  "Massolari/emoji-completefunc.nvim",
  dir = functions.dir_exists(plugin_dir) and plugin_dir or nil,
  config = function()
    vim.opt.complete:append({ "Fv:lua.emoji_completefunc" })
  end,
}
