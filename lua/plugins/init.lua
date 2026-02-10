vim.cmd("packadd cfilter")
if vim.fn.has("nvim-0.12") == 1 then
  vim.cmd("packadd nvim.undotree")
end

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
