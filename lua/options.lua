-- Folding
vim.o.foldmethod = "expr"
vim.o.foldlevelstart = 99

vim.o.confirm = true
vim.o.fileencoding = "utf-8"
vim.o.fileformats = "unix,dos,mac"
vim.opt.formatoptions:remove({ "c" })
vim.opt.formatoptions:remove({ "r" })
vim.opt.formatoptions:remove({ "o" })

-- Indentação
local width = 2
vim.o.tabstop = width
vim.o.shiftwidth = width
vim.o.softtabstop = 0
vim.o.expandtab = true

vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.inccommand = "split"
vim.o.backupcopy = "yes"

-- Shell
local env_shell = os.getenv("SHELL")
local default_shell = "/bin/zsh"
if (nil ~= env_shell) and ("" ~= env_shell) then
  default_shell = env_shell
end
vim.o.shell = default_shell

vim.o.spelllang = "pt_br"
vim.o.scrolloff = 5
vim.o.mouse = "a"
vim.o.number = true
vim.o.relativenumber = true
vim.o.timeoutlen = 500
vim.o.equalalways = false
vim.o.updatetime = 250
vim.opt.shortmess:append("c")
vim.o.signcolumn = "yes"
vim.o.completeopt = "menuone,noselect"
vim.o.termguicolors = true
vim.o.background = "light"
vim.o.guifont = "Iosevka Nerd Font:h13"
vim.o.title = true
if not vim.g.started_by_firenvim then
  vim.o.laststatus = 3
else
  vim.o.laststatus = 0
end
vim.o.list = true
vim.o.listchars = "tab:»·,trail:·,extends:»,precedes:«,nbsp:·"
vim.o.grepprg = "rg --vimgrep --no-heading --smart-case"
vim.o.smoothscroll = true
vim.o.undofile = true

-- Diagnostic
vim.diagnostic.config({
  float = { show_header = true },
  jump = { float = true },
  virtual_lines = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = " ",
      [vim.diagnostic.severity.WARN] = " ",
      [vim.diagnostic.severity.INFO] = " ",
      [vim.diagnostic.severity.HINT] = " ",
    },
  },
})

-- Janela flutuante com fundo transparente
vim.api.nvim_set_hl(0, "NormalFloat", { link = "Normal" })
