(require-macros :hibiscus.vim)

; Encoding
(set! fileencoding "utf-8")
(set! fileformats ["unix" "dos" "mac"])

; Comportamento do Tab
(set! tabstop 4)
(set! softtabstop 0)
(set! shiftwidth 4)
(set! expandtab)

; Busca
(set! ignorecase)
(set! smartcase)
(set! inccommand "split")

; Desabilitar safewrite
(set! backupcopy "yes")

(let [env-shell (os.getenv "SHELL")
      default-shell (if (and (~= nil env-shell) (~= "" env-shell)) env-shell "/bin/bash")]
  (set! shell default-shell))

; Idioma para correção ortográfica
(set! spelllang "pt_br")

; Número mínimo de linha que deverão ser mostradas antes e depois do cursor
(set! scrolloff 5)

; Copiar para a área de transferência
(set! clipboard ["unnamed" "unnamedplus"])

; Mouse
(set! mouse "a")

; Mostra os números da linha de forma relativa e o número atual da linha
(set! number)
(set! relativenumber)

; Diminuir o tempo para executar mapeamentos
(set! timeoutlen 500)

; Realçar linha onde o cursor está
(set! cursorline)

; Não redimensionar janelas abertas ao abrir ou fechar janelas
(set! equalalways false)

; Espaço maior para mensagens
(set! cmdheight 2)

; Diminuir tempo de atualização
(set! updatetime 300)

; Não passar as mensagems para o |ins-completion-menu|
(set+ shortmess "c")

; Deixar a coluna de sinais sempre aberta
(set! signcolumn "yes")

; Autocomplete melhor
(set! completeopt ["menuone" "noselect"])

; Melhora as cores
(set! termguicolors true)

; Tema
(set! background "light")

; Font
(set! guifont "JetBrainsMono Nerd Font")

; Habilitar título
(set! title)

; Destacar espaços em branco no final do arquivo
(vim.fn.matchadd "errorMsg" "\\s\\+$")
