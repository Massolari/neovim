-- Encoding
vim.opt.fileencoding = 'utf-8'
vim.opt.fileformats = { 'unix','dos','mac' }

-- Comportamento do Tab
vim.opt.tabstop = 4
vim.opt.softtabstop = 0
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- Busca
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.inccommand = 'split'

-- Desabilitar safewrite
vim.opt.backupcopy = 'yes'

local envShell = os.getenv('SHELL')
if envShell ~= nil and envShell ~= "" then
  vim.opt.shell = envShell
else
  vim.opt.shell = '/bin/sh'
end

-- Idioma para correção ortográfica
vim.opt.spelllang = 'pt_br'

-- Número mínimo de linha que deverão ser mostradas antes e depois do cursor
vim.opt.scrolloff = 5

vim.opt.clipboard={ 'unnamed', 'unnamedplus' }

-- Mouse
vim.opt.mouse = 'a'

-- Mostra os números da linha de forma relativa e o número atual da linha
vim.opt.number = true
vim.opt.relativenumber = true

-- Diminuir o tempo para executar mapeamentos
vim.opt.timeoutlen = 500

-- Realçar linha onde o cursor está
vim.opt.cursorline = true

-- Não redimensionar janelas abertas ao abrir ou fechar janelas
vim.opt.equalalways = false

-- Espaço maior para mensagens
vim.opt.cmdheight = 2

-- Diminuir tempo de atualização
vim.opt.updatetime = 300

-- Não passar as mensagems para o |ins-completion-menu|
vim.opt.shortmess:append('c')

-- Deixar a coluna de sinais sempre aberta
vim.opt.signcolumn = 'yes'

-- Autocomplete melhor
vim.opt.completeopt = { 'menuone', 'noselect' }

-- Melhora as cores
vim.opt.termguicolors = true

-- Tema
vim.opt.background = 'light'

-- Font
vim.opt.guifont = 'JetBrainsMono Nerd Font'

-- Habilitar título
vim.opt.title = true

-- Destacar espaços em branco no final do arquivo
vim.fn.matchadd('errorMsg', [[\s\+$]])
