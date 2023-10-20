(import-macros {: map!} :hibiscus.vim)

(local wk (require :which-key))

(local options {:buffer nil :silent true :noremap true :nowait true})
(local functions (require :functions))
(local {: require-and : keymaps-set} functions)

; Command

(vim.keymap.set :c :<c-j> :<Down>)
(vim.keymap.set :c :<c-k> :<Up>)

; Insert

(keymaps-set :i [{:lhs :<c-j>
                  :rhs (fn []
                         (local luasnip (require :luasnip))
                         (when (luasnip.expand_or_jumpable)
                           (luasnip.expand_or_jump)))}
                 {:lhs :<c-k>
                  :rhs (fn []
                         (local luasnip (require :luasnip))
                         (when (luasnip.expand_or_jumpable)
                           ((luasnip.jump -1))))}
                 {:lhs :<c-l> :rhs :<Right>}
                 {:lhs :jk :rhs :<Esc>}] options)

; Normal

(wk.register {:<c-n> [:<cmd>bn<CR> "Próximo buffer"]
              :<c-p> [:<cmd>bp<CR> "Buffer anterior"]
              "]" {"]" ["<cmd>call search('^\\w\\+\\s:\\s' 'w')<CR>"
                        "Pular para a próxima função Elm"]
                   :c "Próximo git hunk"
                   :d ["<cmd>lua vim.diagnostic.goto_next({ float =  { show_header = true, border = \"single\" }})<CR>"
                       "Próximo problema (diagnostic)"]
                   :e ["<cmd>lua vim.diagnostic.goto_next({ float =  { show_header = true, border = 'single' }, severity = 'Error' })<CR>"
                       "Próximo erro de código"]
                   :w [#(require-and :illuminate #($.goto_next_reference))
                       "Próxima palavra destacada"]}
              "[" {"[" ["<cmd>call search('^\\w\\+\\s:\\s' 'bW')<CR>"
                        "Pular para a função Elm anterior"]
                   :c "Git hunk anterior"
                   :d [#(vim.diagnostic.goto_prev {:float {:show_header true
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

(wk.register {"," ["mpA,<Esc>`p" "\",\" no fim da linha"]
              ";" ["mpA;<Esc>`p" "\";\" no fim da linha"]
              :<Tab> ["\030" "Alterar para arquivo anterior"]
              := [:<c-w>= "Igualar tamanho das janelas"]
              :/ [:<cmd>noh<cr> "Limpar seleção da pesquisa"]
              :a {:name :Aba
                  :a [:<cmd>tabnew<CR> "Abrir uma nova"]
                  :c [:<cmd>tabclose<CR> "Fechar (close)"]
                  :n [:<cmd>tabnext<CR> "Ir para a próxima (next)"]
                  :p [:<cmd>tabprevious<CR> "Ir para a anterior (previous)"]}
              :b {:name :Buffer
                  :a [:ggVG "Selecionar tudo (all)"]
                  :b [#(require-and :telescope.builtin
                                    #($.buffers (require-and :telescope.themes
                                                             #($.get_dropdown {}))))
                      "Listar abertos"]
                  :d ["<cmd>bp|bd #<CR>" :Deletar]
                  :D [:<cmd>bd<CR> "Deletar e fechar janela"]
                  :o ["<cmd>%bd|e#|bd#<CR>" "Deletar todos os outros buffers"]
                  :s [:<cmd>w<CR> :Salvar]}
              :c {:name :Code
                  :d [#(vim.diagnostic.setqflist) "Problemas (diagnostics)"]
                  :e [#(vim.diagnostic.open_float 0 {:border :single})
                      "Mostrar erro da linha"]
                  :f [#(functions.format) "Formatar código"]
                  :i [#(vim.lsp.inlay_hint 0)
                      "Ativar/desativar dicas de código"]
                  :q [#(vim.lsp.buf.code_action {:context {:only [:quickfix]}
                                                 :apply true})
                      :Corrigir]
                  :r [#(vim.lsp.buf.rename) "Renomear Variável"]}
              :e {:name :Editor
                  :a {:name :Animais
                      :c [#(functions.cook-animals) :Cozinhar]
                      :s [#(functions.release-animals) :Soltar]}
                  :c {:name :ChatGPT}
                  :f {:name :Forem
                      :f ["<cmd>lua require'forem-nvim'.feed()<CR>" :Feed]
                      :m ["<cmd>lua require'forem-nvim'.my_articles()<CR>"
                          "Meus artigos"]
                      :n ["<cmd>lua require'forem-nvim'.new_article()<CR>"
                          "Novo artigo"]}
                  :g [#(functions.vim-grep) "Buscar com vimgrep"]
                  :q [:<cmd>qa<CR> :Fechar]
                  :u [:<cmd>Lazy<CR> :Plugins]}
              :g {:name :Git
                  :b {:name :Blame :b :Linha}
                  :h {:name :Hunks :u "Desfazer (undo)" :v :Ver}
                  :i {:name "Issues (Github)"}
                  :k [#(functions.checkout-new-branch)
                      "Criar branch e fazer checkout"]
                  :u {:name "Pull Requests (Github)"}}
              :h ["<cmd>split<CR> " "Dividir horizontalmente"]
              :i ["mpgg=G`p" "Indentar arquivo"]
              :l [#(functions.toggle-location-list) "Alternar locationlist"]
              ;; :m {:name :Markdown
              ;; :m [:<cmd>Glow<CR> "Pré-visualizar com glow"]
              ;; :b [:<cmd>MarkdownPreview<CR>
              ;;     "Pré-visualizar com navegador (browser)"]}
              :o {:name :Obsidian
                  ;; :i ["<cmd>exe 'edit' stdpath('config').'/init.fnl'<CR>"
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
              :q [#(functions.toggle-quickfix) "Alternar quickfix"]
              :s {:name "Sessão"
                  :c [:<cmd>SessionLoad<CR> :Carregar]
                  :l [#(functions.session-list) :Listar]
                  :s [:<cmd>SessionSave<CR> :Salvar]}
              :t ["<cmd>exe v:count1 . \"ToggleTerm\"<CR>" :Terminal]
              :v [:<cmd>vsplit<CR> "Dividir verticalmente"]
              :w {:name :Window
                  :c [:<c-w>c "Fechar janela"]
                  :o [:<c-w>o "Fechar outras janelas"]}}
             (vim.tbl_extend :force options {:mode :n :prefix :<leader>}))

; Toda a vez que pular para próxima palavra buscada o cursor fica no centro da tela

(map! [:n :nowait] :n :nzzzv)
(map! [:n :nowait] :N :Nzzzv)
; Mover cursor para outra janela divida

(map! [:n] :<C-j> :<C-w>j)
(map! [:n] :<C-k> :<C-w>k)
(map! [:n] :<C-l> :<C-w>l)
(map! [:n] :<C-h> :<C-w>h)

; Limpar espaços em branco nos finais da linha

(map! [:n] :<F5> "mp<cmd>%s/\\s\\+$/<CR>`p")

; Enter no modo normal funciona como no modo inserção

(map! [:n] :<CR> :i<CR><Esc>)

; Setas redimensionam janelas adjacentes

(map! [:n] :<left> "<cmd>vertical resize -5<cr>")
(map! [:n] :<right> "<cmd>vertical resize +5<cr>")
(map! [:n] :<up> "<cmd>resize -5<cr>")
(map! [:n] :<down> "<cmd>resize +5<cr>")

; Mover de forma natural em wrap

(map! [:n :expr] :k "v:count == 0 ? 'gk' : 'k'")
(map! [:n :expr] :j "v:count == 0 ? 'gj' : 'j'")

; Manter seleção depois de indentação

(map! [:v] "<" :<gv)
(map! [:v] ">" :>gv)

; Mover linhas

(map! [:v] :K ":m '<-2<CR>gv=gv")
(map! [:v] :J ":m '>+1<CR>gv=gv")

(map! [:n] :K #(vim.lsp.buf.hover))

(wk.register {:i [#(vim.lsp.buf.implementation) "Implementação"]
              :r ["<cmd>lua require'telescope.builtin'.lsp_references()<CR>"
                  "Referências"]
              :y ["<cmd>lua require'telescope.builtin'.lsp_type_definitions()<CR>"
                  "Definição do tipo"]}
             (vim.tbl_extend :force options {:mode :n :prefix :g}))

(vim.keymap.set [:n :o :x] :ge :G {:desc "Goto last line"})
(vim.keymap.set [:n :o :x] :gh :0 {:desc "Goto line start"})
(vim.keymap.set [:n :o :x] :gl "$" {:desc "Goto line end"})
(vim.keymap.set [:n :o :x] :gs "^" {:desc "Goto first non-blank in line"})

(vim.cmd.iab ",\\ λ")
(map! [:nivcx :remap] :<c-m> :<CR>)

; Gerar imagem do código usando silicon
(map! [:v] :<leader>ei ":Silicon<CR>" "Gerar imagem do código (silicon)")

; Treesitter
(vim.keymap.set :n :<M-o> :vgrn {:remap true})
(vim.keymap.set :x :<M-o> :grn {:remap true})
(vim.keymap.set :x :<M-i> :grm {:remap true})

; Múltiplos cursores
(vim.keymap.set :x :<C-s> "\\\\/" {:remap true})
