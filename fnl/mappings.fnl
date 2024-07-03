(local wk (require :which-key))

(local options {:buffer nil :silent true :noremap true :nowait true})
(local functions (require :functions))
(local {: require-and : keymaps-set : get-key-insert} functions)

; Insert

(keymaps-set :i
             [[:<c-j>
               (fn []
                 (if (vim.snippet.active {:direction 1})
                     (vim.snippet.jump 1)
                     (vim.api.nvim_feedkeys (get-key-insert :<Down>) :n [])))]
              [:<c-k>
               (fn []
                 (if (vim.snippet.active {:direction -1})
                     (vim.snippet.jump -1)
                     (vim.api.nvim_feedkeys (get-key-insert :<Up>) :n [])))]])

; Normal

(vim.keymap.set :n :<c-n> :<cmd>bn<CR> {:desc "Próximo buffer"})
(vim.keymap.set :n :<c-p> :<cmd>bp<CR> {:desc "Buffer anterior"})

(wk.register {"]" {:d [#(vim.diagnostic.goto_next {:float {:show_header true
                                                           :border :single}})
                       "Próximo problema (diagnostic)"]
                   :e [#(vim.diagnostic.goto_next {:float {:show_header true
                                                           :border :single}
                                                   :severity :Error})
                       "Próximo erro de código"]
                   :w [#(require-and :illuminate #($.goto_next_reference))
                       "Próxima palavra destacada"]}
              "[" {:d [#(vim.diagnostic.goto_prev {:float {:show_header true
                                                           :border :single}})
                       "Problema anterior (diagnostic)"]
                   :e [#(vim.diagnostic.goto_prev {:float {:show_header true
                                                           :border :single}
                                                   :severity :Error})
                       "Erro de código anterior"]
                   :w [#(require-and :illuminate #($.goto_prev_reference))
                       "Palavra destacada anterior"]}}
             (vim.tbl_extend :force options {:mode :n}))

; Normal com leader
(keymaps-set :n
             [["."
               #(vim.lsp.buf.code_action {:context {:only [:quickfix]}
                                          :apply true})
               {:desc :Corrigir}]
              ["," "mpA,<Esc>`p" {:desc "\",\" no fim da linha"}]
              [";" "mpA;<Esc>`p" {:desc "\";\" no fim da linha"}]
              [:<Tab> "\030" {:desc "Alterar para arquivo anterior"}]
              ["=" :<c-w>= {:desc "Igualar tamanho das janelas"}]
              ["%" :ggVG {:desc "Selecionar tudo"}]
              [:d "<cmd>bn|bd #<CR>" {:desc "Deletar buffer"}]
              [:D :<cmd>bd<CR> {:desc "Deletar buffer e fechar janela"}]
              [:n :<cmd>noh<cr> {:desc "Limpar seleção da pesquisa"}]
              [:q #(functions.toggle-quickfix) {:desc "Alternar quickfix"}]
              [:v :<cmd>vsplit<CR> {:desc "Dividir verticalmente"}]
              [:s :<cmd>w<CR> {:desc "Salvar buffer"}]
              ["/" #(functions.grep) {:desc "Buscar com ripgrep"}]]
             {:prefix :<leader>})

; Aba
(keymaps-set :n [[:a :<cmd>tabnew<CR> {:desc "Abrir uma nova"}]
                 [:c :<cmd>tabclose<CR> {:desc "Fechar (close)"}]
                 [:n :<cmd>tabnext<CR> {:desc "Ir para a próxima (next)"}]
                 [:p
                  :<cmd>tabprevious<CR>
                  {:desc "Ir para a anterior (previous)"}]]
             {:prefix :<leader>a})

; Editor
(keymaps-set :n [[:b
                  #(require-and :nvim-web-browser #($.open))
                  {:desc "Navegador (browser)"}]
                 [:c #(functions.start-ltex) {:desc :Corretor}]
                 [:hf
                  #(require-and :telescope.builtin
                                #($.find_files {:cwd "~/.local/share/nvim/rest"}))
                  {:desc :Abrir}]
                 [:hn
                  #(functions.with-input "Novo arquivo: "
                     (fn [name]
                       (when (not= name "")
                         (vim.cmd.e (.. "~/.local/share/nvim/rest/" name :.rest)))))
                  {:desc :Novo}]
                 ; [:ff "<cmd>lua require'forem-nvim'.feed()<CR>" {:desc :Feed}]
                 ; [:fm
                 ;  "<cmd>lua require'forem-nvim'.my_articles()<CR>"
                 ;  {:desc "Meus artigos"}]
                 ; [:fn
                 ;  "<cmd>lua require'forem-nvim'.new_article()<CR>"
                 ;  {:desc "Novo artigo"}]
                 [:q :<cmd>qa<CR> {:desc :Fechar}]
                 [:u :<cmd>Lazy<CR> {:desc :Plugins}]]
             {:prefix :<leader>e})

(wk.register {:a {:name :Aba}
              :b {:name :Buffer}
              :c {:name :Code
                  :d [#(require-and :trouble #($.toggle :workspace_diagnostics))
                      "Problemas (diagnostics)"]
                  :e [#(vim.diagnostic.open_float 0 {:border :single})
                      "Mostrar erro da linha"]
                  :f [#(require-and :conform #($.format)) "Formatar código"]
                  :i [#(vim.lsp.inlay_hint.enable (not (vim.lsp.inlay_hint.is_enabled)))
                      "Ativar/desativar dicas de código"]
                  :r [#(vim.lsp.buf.rename) "Renomear Variável"]}
              :d {:name :Debug}
              :e {:name :Editor :h {:name "Cliente HTTP"}}
              :g {:name :Git
                  :b {:name :Blame}
                  :h {:name :Hunks}
                  :i {:name "Issues (Github)"}
                  :u {:name "Pull Requests (Github)"}}
              :h ["<cmd>split<CR> " "Dividir horizontalmente"]
              :i ["mpgg=G`p" "Indentar arquivo"]
              :l [#(functions.toggle-location-list) "Alternar locationlist"]
              :o {:name :Obsidian
                  :f [#(require-and :telescope.builtin
                                    #($.find_files {:cwd vim.g.obsidian_dir}))
                      "Abrir arquivo"]
                  :n [#(let [vaults (-> (.. "^ls '" vim.g.obsidian_dir "'")
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
                                                               name))))))))
                      "Novo arquivo"]}
              :p {:name :Projeto}
              :w {:name :Window
                  :c [:<c-w>c "Fechar janela"]
                  :o [:<c-w>o "Fechar outras janelas"]}}
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

(wk.register {:i [#(vim.lsp.buf.implementation) "Implementação"]
              :r ["<cmd>lua require'telescope.builtin'.lsp_references()<CR>"
                  "Referências"]
              :Y ["<cmd>lua require'telescope.builtin'.lsp_type_definitions()<CR>"
                  "Definição do tipo"]}
             (vim.tbl_extend :force options {:mode :n :prefix :g}))

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
