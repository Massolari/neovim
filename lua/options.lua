-- Encoding
vim.o.fileencoding = "utf-8"

-- Folding
vim.o.foldmethod = "expr"
vim.o.foldlevelstart = 99

vim.o.confirm = true
vim.o.fileformats = "unix,dos,mac"
vim.opt.formatoptions:remove({ "c" })

-- Indentação
local width = 2
vim.o.tabstop = width
vim.o.shiftwidth = width
vim.o.expandtab = true

vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.inccommand = "split"

-- Shell
local env_shell = os.getenv("SHELL")
local default_shell = "/bin/zsh"
if env_shell and (env_shell ~= "") then
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
vim.opt.shortmess:remove("l")
vim.o.signcolumn = "yes"
vim.o.title = true
vim.o.laststatus = 3
vim.o.list = true
vim.o.listchars = "tab:»·,trail:·,extends:»,precedes:«,nbsp:·"
vim.o.grepprg = "rg --vimgrep --no-heading --smart-case"
vim.o.smoothscroll = true
vim.o.undofile = true

-- Bordas em janelas flutuantes
vim.o.winborder = "rounded"

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
vim.schedule(function()
  vim.api.nvim_set_hl(0, "NormalFloat", { link = "Normal" })
end)
-- Habilita arquivo de configuração local
vim.o.exrc = true

vim.o.cmdheight = 0

vim.opt.wildmode = { "noselect:lastused", "full" }
vim.o.wildoptions = "pum"

vim.opt.completeopt = { "menuone", "longest", "popup", "fuzzy" }
vim.opt.completeitemalign = { "kind", "abbr", "menu" }
-- Check if Neovim is version 0.12 or higher
if vim.fn.has("nvim-0.12") == 1 then
  require("vim._core.ui2").enable({
    enable = true, -- Whether to enable or disable the UI.
    msg = { -- Options related to the message module.
      ---@type 'cmd'|'msg' Where to place regular messages, either in the
      ---cmdline or in a separate ephemeral message window.
      target = "msg",
      timeout = 4000, -- Time a message is visible in the message window.
    },
  })
  vim.o.autocomplete = true
  vim.opt.complete = { "o^30", ".", "w", "b" }
  vim.o.pumborder = "rounded"
  vim.o.pumheight = 15
  vim.o.pummaxwidth = 80
end
