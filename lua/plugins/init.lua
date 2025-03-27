local functions = require("functions")
vim.cmd("packadd cfilter")

local plugins = {
  {
    "Massolari/web.nvim",
    cond = functions["dir_exists"]((vim.env.HOME .. "/nvim-web-browser")),
    dir = (vim.env.HOME .. "/nvim-web-browser"),
    dependencies = "nvim-lua/plenary.nvim",
  },
}

local _, user_plugins = xpcall(function()
  return require("user.plugins")
end, function()
  return {}
end)

for _, user_plugin in pairs(user_plugins) do
  table.insert(plugins, user_plugin)
end

return plugins
