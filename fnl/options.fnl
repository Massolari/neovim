(set vim.opt.tagfunc "v:lua.vim.lsp.tagfunc")

; Perguntar se deseja salvar o arquivo antes de sair
(set vim.opt.confirm true)

; Encoding

(set vim.opt.fileencoding :utf-8)
(set vim.opt.fileformats "unix,dos,mac")

; Formatação

(vim.opt.formatoptions:remove [:c])
(vim.opt.formatoptions:remove [:r])
(vim.opt.formatoptions:remove [:o])

; Comportamento do Tab

(let [width 2]
  (set vim.opt.tabstop width)
  (set vim.opt.shiftwidth width))

(set vim.opt.softtabstop 0)
(set vim.opt.expandtab true)

; Busca

(set vim.opt.ignorecase true)
(set vim.opt.smartcase true)
(set vim.opt.inccommand :split)

; Desabilitar safewrite

(set vim.opt.backupcopy :yes)

(let [env-shell (os.getenv :SHELL)
      default-shell (if (and (not= nil env-shell) (not= "" env-shell))
                        env-shell
                        :/bin/zsh)]
  (set vim.opt.shell default-shell))

; Idioma para correção ortográfica

(set vim.opt.spelllang :pt_br)

; Número mínimo de linha que deverão ser mostradas antes e depois do cursor

(set vim.opt.scrolloff 5)

; Mouse

(set vim.opt.mouse :a)

; Mostra os números da linha de forma relativa e o número atual da linha

(set vim.opt.number true)
(set vim.opt.relativenumber true)

; Diminuir o tempo para executar mapeamentos

(set vim.opt.timeoutlen 500)

; Não redimensionar janelas abertas ao abrir ou fechar janelas

(set vim.opt.equalalways false)

; Diminuir tempo de atualização

(set vim.opt.updatetime 300)

; Não passar as mensagems para o |ins-completion-menu|

(vim.opt.shortmess:append :c)

; Deixar a coluna de sinais sempre aberta

(set vim.opt.signcolumn :yes)

; Autocomplete melhor

(set vim.opt.completeopt "menuone,noselect")

; Melhora as cores

(set vim.opt.termguicolors true)

; Tema

(set vim.opt.background :light)

; Font

(set vim.opt.guifont "Iosevka Nerd Font:h13")

; Habilitar título

(set vim.opt.title true)

; Statusline

(set vim.opt.laststatus (if (not vim.g.started_by_firenvim) 3 0))
; Listchars

(set vim.opt.list true)
(set vim.opt.listchars "tab:»·,trail:·,extends:»,precedes:«,nbsp:·")

; Usar ripgrep for :grep
(set vim.opt.grepprg "rg --vimgrep --no-heading --smart-case")

; Rolar a página apenas uma linha mesmo o texto ocupando mais de uma linha
(set vim.opt.smoothscroll true)
