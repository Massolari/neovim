(local wk (require :which-key))

(local options {:buffer nil :silent true :noremap true :nowait true})
(local functions (require :functions))

; Insert

(functions.keymaps-set :i
                       [[:<c-j>
                         (fn []
                           (if (vim.snippet.active {:direction 1})
                               (vim.snippet.jump 1)
                               (vim.api.nvim_feedkeys (functions.get-key-insert :<Down>)
                                                      :n [])))]
                        [:<c-k>
                         (fn []
                           (if (vim.snippet.active {:direction -1})
                               (vim.snippet.jump -1)
                               (vim.api.nvim_feedkeys (functions.get-key-insert :<Up>)
                                                      :n [])))]])

; Normal

(vim.keymap.set :n :<c-n> :<cmd>bn<CR> {:desc "Próximo buffer"})
(vim.keymap.set :n :<c-p> :<cmd>bp<CR> {:desc "Buffer anterior"})
(vim.keymap.set :n :U :<c-r> {:desc :Refazer})

;; Próximo diagnostic
(vim.keymap.set :n "]d"
                #(vim.diagnostic.goto_next {:float {:show_header true
                                                    :border :single}})
                {:desc "Próximo problema (diagnostic)"})

;; Próximo erro
(vim.keymap.set :n "]e"
                #(vim.diagnostic.goto_next {:float {:show_header true
                                                    :border :single}
                                            :severity :Error})
                {:desc "Próximo erro de código"})

;; Diagnostic anterior
(vim.keymap.set :n "[d"
                #(vim.diagnostic.goto_prev {:float {:show_header true
                                                    :border :single}})
                {:desc "Problema anterior (diagnostic)"})

;; Erro anterior
(vim.keymap.set :n "[e"
                #(vim.diagnostic.goto_prev {:float {:show_header true
                                                    :border :single}
                                            :severity :Error})
                {:desc "Erro de código anterior"})

; Normal com leader
(functions.keymaps-set :n
                       [["."
                         #(vim.lsp.buf.code_action {:context {:only [:quickfix]}
                                                    :apply true})
                         {:desc :Corrigir}]
                        ["=" "mpgg=G`p" {:desc "Indentar arquivo"}]
                        ["," "mpA,<Esc>`p" {:desc "\",\" no fim da linha"}]
                        [";" "mpA;<Esc>`p" {:desc "\";\" no fim da linha"}]
                        [:<Tab> "\030" {:desc "Alterar para arquivo anterior"}]
                        ["%" :ggVG {:desc "Selecionar tudo"}]
                        [:D
                         :<cmd>bd<CR>
                         {:desc "Deletar buffer e fechar janela"}]
                        [:F
                         #(functions.require-and :conform #($.format))
                         {:desc "Formatar código"}]
                        [:n
                         :<cmd>noh<cr>
                         {:desc "Limpar seleção da pesquisa"}]
                        [:q
                         #(functions.toggle-quickfix)
                         {:desc "Alternar quickfix"}]
                        [:v :<cmd>vsplit<CR> {:desc "Dividir verticalmente"}]
                        [:s :<cmd>w<CR> {:desc "Salvar buffer"}]
                        ["/" #(functions.grep) {:desc "Buscar com ripgrep"}]]
                       {:prefix :<leader>})

; Aba
(functions.keymaps-set :n
                       [[:a :<cmd>tabnew<CR> {:desc "Abrir uma nova"}]
                        [:c :<cmd>tabclose<CR> {:desc "Fechar (close)"}]
                        [:n
                         :<cmd>tabnext<CR>
                         {:desc "Ir para a próxima (next)"}]
                        [:p
                         :<cmd>tabprevious<CR>
                         {:desc "Ir para a anterior (previous)"}]]
                       {:prefix :<leader>a})

; Código
(functions.keymaps-set :n
                       [[:d
                         #(functions.require-and :trouble
                                                 #($.toggle :diagnostics))
                         {:desc "Problemas (diagnostics)"}]
                        [:e
                         #(vim.diagnostic.open_float 0 {:border :single})
                         {:desc "Mostrar erro da linha"}]
                        [:i
                         #(vim.lsp.inlay_hint.enable (not (vim.lsp.inlay_hint.is_enabled)))
                         {:desc "Ativar/desativar dicas de código"}]]
                       {:prefix :<leader>c})

; Editor
(functions.keymaps-set :n
                       [[:b
                         #(functions.require-and :nvim-web-browser #($.open))
                         {:desc "Navegador (browser)"}]
                        [:c #(functions.start-ltex) {:desc :Corretor}]
                        [:hn
                         #(functions.with-input "Novo arquivo: "
                            (fn [name]
                              (when (not= name "")
                                (vim.cmd.e (.. (vim.fn.stdpath :data) :/rest/
                                               name :.http)))))
                         {:desc :Novo}]
                        [:N
                         #(vim.cmd.edit (.. vim.g.obsidian_dir :/Notas/Notas.md))
                         {:desc "Abrir notas"}]
                        [:nn
                         (fn []
                           (let [vaults (-> (.. "ls '" vim.g.obsidian_dir "'")
                                            (vim.fn.system)
                                            (vim.fn.split "\n"))]
                             (vim.ui.select vaults
                                            {:prompt "Cofre para novo arquivo"}
                                            (fn [vault]
                                              (functions.with-input "Novo arquivo: "
                                                (fn [name]
                                                  (when (not= name "")
                                                    (vim.cmd.e (.. vim.g.obsidian_dir
                                                                   "/" vault "/"
                                                                   name)))))))))
                         {:desc "Novo arquivo"}]
                        [:q :<cmd>qa<CR> {:desc :Fechar}]
                        [:u :<cmd>Lazy<CR> {:desc :Plugins}]]
                       {:prefix :<leader>e})

(wk.add [{1 :<leader>a :group :Aba :nowait true :remap false}
         {1 :<leader>b :group :Buffer :nowait true :remap false}
         {1 :<leader>c :group :Code :nowait true :remap false}
         {1 :<leader>d :group :Debug :nowait true :remap false}
         {1 :<leader>e :group :Editor :nowait true :remap false}
         {1 :<leader>eh :group "Cliente HTTP" :nowait true :remap false}
         {1 :<leader>g :group :Git :nowait true :remap false}
         {1 :<leader>gb :group :Blame :nowait true :remap false}
         {1 :<leader>gh :group :Hunks :nowait true :remap false}
         {1 :<leader>gi :group "Issues (Github)" :nowait true :remap false}
         {1 :<leader>gu
          :group "Pull Requests (Github)"
          :nowait true
          :remap false}
         {1 :<leader>h
          2 :<cmd>split<CR>
          :desc "Dividir horizontalmente"
          :nowait true
          :remap false}
         {1 :<leader>i
          :group "Inteligência Artificial"
          :nowait true
          :remap false}
         {1 :<leader>l
          2 #(functions.toggle-location-list)
          :desc "Alternar locationlist"
          :nowait true
          :remap false}
         {1 :<leader>en :group :Notas :nowait true :remap false}
         {1 :<leader>p :group :Projeto :nowait true :remap false}
         {1 :<leader>w :group :Window :proxy :<C-w> :nowait true :remap false}]
        (vim.tbl_extend :force options {:mode :n :prefix :<leader>}))

; Toda a vez que pular para próxima palavra buscada o cursor fica no centro da tela

(vim.keymap.set :n :n :nzzzv {:nowait true})
(vim.keymap.set :n :N :Nzzzv {:nowait true})
; Mover cursor para outra janela divida

(vim.keymap.set :n :<C-j> :<C-w>j)
(vim.keymap.set :n :<C-k> :<C-w>k)
(vim.keymap.set :n :<C-l> :<C-w>l)
(vim.keymap.set :n :<C-h> :<C-w>h)

; Limpar espaços em branco nos finais da linha

(vim.keymap.set :n :<F5> "mp<cmd>%s/\\s\\+$/<CR>`p")

; Enter no modo normal funciona como no modo inserção

(vim.keymap.set :n :<CR> :i<CR><Esc>)

; Setas redimensionam janelas adjacentes

(vim.keymap.set :n :<left> "<cmd>vertical resize -5<cr>")
(vim.keymap.set :n :<right> "<cmd>vertical resize +5<cr>")
(vim.keymap.set :n :<up> "<cmd>resize -5<cr>")
(vim.keymap.set :n :<down> "<cmd>resize +5<cr>")

; Mover de forma natural em wrap

(vim.keymap.set :n :k "v:count == 0 ? 'gk' : 'k'" {:expr true})
(vim.keymap.set :n :j "v:count == 0 ? 'gj' : 'j'" {:expr true})

; Manter seleção depois de indentação

(vim.keymap.set :v "<" :<gv)
(vim.keymap.set :v ">" :>gv)

; Mover linhas

(vim.keymap.set :v :K ":m '<-2<CR>gv=gv")
(vim.keymap.set :v :J ":m '>+1<CR>gv=gv")

(vim.keymap.set [:n :o :x] :ge :G {:desc "Ir para última linha"})
(vim.keymap.set [:n :o :x] :gh :0 {:desc "Ir para início da linha"})
(vim.keymap.set [:n :o :x] :gl "$" {:desc "Ir para fim da linha"})
(vim.keymap.set [:n :x] :gp "\"+p" {:desc "Colar da área de transferência"})
(vim.keymap.set [:n :x] :gP "\"+P"
                {:desc "Colar da área de transferência antes do cursor"})

(vim.keymap.set [:n :o :x] :gs "^"
                {:desc "Ir para primeiro caractere não branco"})

(vim.keymap.set [:n :x] :gy "\"+y"
                {:desc "Copiar para área de transferência"})

(vim.cmd.iab ",\\ λ")
(vim.keymap.set [:n :i :v :c :x] :<c-m> :<CR> {:remap true})

; Gerar imagem do código usando silicon
(vim.keymap.set :v :<leader>ei ":Silicon<CR>"
                {:desc "Gerar imagem do código (silicon})"})

; Treesitter
(vim.keymap.set :n :<M-o> :vgrn {:remap true})
(vim.keymap.set :x :<M-o> :grn {:remap true})
(vim.keymap.set :x :<M-i> :grm {:remap true})

; Múltiplos cursores
(vim.keymap.set :x :<C-s> "\\\\/" {:remap true})

;; LSP

(vim.keymap.set :n :gra #(vim.lsp.buf.code_action) {:desc "Ações"})
(vim.keymap.set :n :grn #(vim.lsp.buf.rename) {:desc "Renomear Variável"})
(vim.keymap.set :n :grf #(vim.lsp.buf.format) {:desc "Formatar arquivo"})
