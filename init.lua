local functions = require("functions")

-- Lazy initialization
local lazypath = (vim.fn.stdpath("data") .. "/lazy/lazy.nvim")
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--single-branch",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.runtimepath:prepend(lazypath)

require("globals")
require("options")

require("lazy").setup({ spec = { import = "plugins" } })

require("commands")
require("autocommands")
require("mappings")

-- Load user config
local user_file = vim.fn.stdpath("config") .. "/lua/user/init.lua"
if functions.file_exists(user_file) then
  require("user")
end
