vim.opt.confirm = true
vim.opt.fileencoding = "utf-8"
vim.opt.fileformats = "unix,dos,mac"
vim.opt.formatoptions:remove({ "c" })
vim.opt.formatoptions:remove({ "r" })
vim.opt.formatoptions:remove({ "o" })

-- Indentação
local width = 2
vim.opt.tabstop = width
vim.opt.shiftwidth = width
vim.opt.softtabstop = 0
vim.opt.expandtab = true

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.inccommand = "split"
vim.opt.backupcopy = "yes"

-- Shell
local env_shell = os.getenv("SHELL")
local default_shell = "/bin/zsh"
if (nil ~= env_shell) and ("" ~= env_shell) then
  default_shell = env_shell
end
vim.opt.shell = default_shell

vim.opt.spelllang = "pt_br"
vim.opt.scrolloff = 5
vim.opt.mouse = "a"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.timeoutlen = 500
vim.opt.equalalways = false
vim.opt.updatetime = 250
vim.opt.shortmess:append("c")
vim.opt.signcolumn = "yes"
vim.opt.completeopt = "menuone,noselect"
vim.opt.termguicolors = true
vim.opt.background = "light"
vim.opt.guifont = "Iosevka Nerd Font:h13"
vim.opt.title = true
if not vim.g.started_by_firenvim then
  vim.opt.laststatus = 3
else
  vim.opt.laststatus = 0
end
vim.opt.list = true
vim.opt.listchars = "tab:»·,trail:·,extends:»,precedes:«,nbsp:·"
vim.opt.grepprg = "rg --vimgrep --no-heading --smart-case"
vim.opt.smoothscroll = true
vim.opt.undofile = true
vim.diagnostic.config({ float = { show_header = true }, jump = { float = true }, virtual_lines = true })
