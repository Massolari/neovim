local M = {}

--- Show a notification
--- @param message string
--- @param level number
--- @param title string
--- @param options? table
local function show(message, level, title, options)
  options = options or {}
  options.title = title
  vim.notify(message, level, options)
end

--- Show a warning notification
--- @param message string
--- @param title string
--- @param options? table
M.warning = function(message, title, options)
  show(message, vim.log.levels.WARN, title, options)
end

--- Show an info notification
--- @param message string
--- @param title string
--- @param options? table
M.info = function(message, title, options)
  show(message, vim.log.levels.INFO, title, options)
end

--- Show an error notification
--- @param message string
--- @param title string
--- @param options? table
M.error = function(message, title, options)
  show(message, vim.log.levels.ERROR, title, options)
end

return M
