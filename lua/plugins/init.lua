vim.cmd("packadd cfilter")
vim.cmd("packadd nvim.undotree")

local _, user_plugins = xpcall(function()
  return require("user.plugins")
end, function()
  return {}
end)

local plugins = {}

for _, user_plugin in pairs(user_plugins) do
  table.insert(plugins, user_plugin)
end

return plugins
