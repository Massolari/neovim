vim.loader.enable(true)
local functions = require("functions")

local function load_plugins()
  for name, type in vim.fs.dir(vim.fn.stdpath("config") .. "/lua/plugins") do
    if type == "file" then
      local name_without_extension = string.sub(name, 1, -5) -- Remove `.lua`
      require("plugins." .. name_without_extension)
    end
  end
end

require("lsp")
require("globals")
require("options")
require("autocommands")

require("plugins.themes")
load_plugins()

require("commands")
require("mappings")

-- Load user config
local user_file = vim.fn.stdpath("config") .. "/lua/user/init.lua"
if functions.file_exists(user_file) then
  require("user")
end

-- vim.cmd.colorscheme("catppuccin")
vim.schedule(function()
  -- vim.api.nvim_set_hl(0, "Pmenu", { link = "Normal", force = true })
  vim.api.nvim_set_hl(0, "NormalFloat", { link = "Normal", force = true })
  vim.api.nvim_set_hl(0, "FloatBorder", { link = "@text.title" })
  -- vim.api.nvim_set_hl(0, "FloatBorder", { link = "PmenuBorder", force = true })
  vim.api.nvim_set_hl(0, "TreesitterContextBottom", { underline = true })
end)
