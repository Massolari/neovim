(require-macros :hibiscus.vim)

(local wk (require :which-key))
(local luasnip (require :luasnip))

(local options {:buffer nil :silent true :noremap true :nowait true})
(local functions (require :functions))
(local illuminate (require :illuminate))

; Command
(wk.register {:<c-j> [:<Down> "Comando anterior executado mais recente"]
              :<c-k> [:<Up> "Próximo comando executado mais recente"]}
             {:mode :c :silent false})

; Insert
(wk.register {:<c-j> [(fn []
                        (when (luasnip.expand_or_jumpable)
                          (luasnip.expand_or_jump)))
                      "Expande o snippet ou pula para o item seguinte"]
              :<c-l> [:<right> "Move o cursor para a direita"]
              :jk [:<Esc> "Ir para o modo normal"]
              :kj [:<Esc> "Ir para o modo normal"]}
             (vim.tbl_extend :force options {:mode :i}))

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
                   :w [#(illuminate.goto_next_reference)
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
                   :w [#(illuminate.goto_prev_reference)
                       "Palavra destacada anterior"]}}
             (vim.tbl_extend :force options {:mode :n}))

; Normal com leader
(wk.register {"," ["mpA,<Esc>`p" "\",\" no fim da linha"]
              ";" ["mpA;<Esc>`p" "\";\" no fim da linha"]
              :<Tab> ["\030" "Alterar para arquivo anterior"]
              := [:<c-w>= "Igualar tamanho das janelas"]
              :<space> [:<cmd>noh<cr> "Limpar seleção da pesquisa"]
              :a {:name :Aba
                  :a [:<cmd>tabnew<CR> "Abrir uma nova"]
                  :c [:<cmd>tabclose<CR> "Fechar (close)"]
                  :n [:<cmd>tabnext<CR> "Ir para a próxima (next)"]
                  :p [:<cmd>tabprevious<CR> "Ir para a anterior (previous)"]}
              :b {:name :Buffer
                  :a [:ggVG "Selecionar tudo (all)"]
                  :b ["<cmd>lua require'telescope.builtin'.buffers()<CR>"
                      "Listar abertos"]
                  :d ["<cmd>bp|bd #<CR>" :Deletar]
                  :D [:<cmd>bd<CR> "Deletar e fechar janela"]
                  :j [:<cmd>BufferLinePick<CR> "Pular (jump) para buffer"]
                  :s [:<cmd>w<CR> :Salvar]}
              :c {:name :Code
                  :a [#(vim.lsp.buf.code_action) "Ações"]
                  :d [#(vim.diagnostic.setqflist) "Problemas (diagnostics)"]
                  :e [#(vim.diagnostic.open_float 0 {:border :single})
                      "Mostrar erro da linha"]
                  :f [#(vim.lsp.buf.format {:async true}) "Formatar código"]
                  :o ["<cmd>lua require'telescope.builtin'.lsp_document_symbols()<CR>"
                      "Buscar símbolos no arquivo"]
                  :p ["<cmd>lua require'telescope.builtin'.lsp_workspace_symbols()<CR>"
                      "Buscar símbolos no projeto"]
                  :r [#(vim.lsp.buf.rename) "Renomear Variável"]}
              :e {:name :Editor
                  :a {:name :Animais
                      :c [#(functions.cook-animals) :Cozinhar]
                      :s [#(functions.release-animals) :Soltar]}
                  :b {:name "Browser (w3m)"
                      :a [#(functions.w3m-open-url) "Abrir URL"]
                      :s [#(functions.w3m-search) "Buscar no Google (search)"]
                      :t [#(functions.w3m-open) :Toggle]}
                  :c ["<cmd>lua require'telescope.builtin'.colorscheme()<CR>"
                      "Temas (colorscheme)"]
                  :f {:name :Forem
                      :f ["<cmd>lua require'forem-nvim'.feed()<CR>" :Feed]
                      :m ["<cmd>lua require'forem-nvim'.my_articles()<CR>"
                          "Meus artigos"]
                      :n ["<cmd>lua require'forem-nvim'.new_article()<CR>"
                          "Novo artigo"]}
                  :g [#(functions.vim-grep) "Buscar com vimgrep"]
                  :h [:<cmd>Cheat<CR> "Procurar em cheat.sh"]
                  :i [#(functions.display-image (vim.fn.expand :<cfile>))
                      "Exibir imagem sob o cursor"]
                  :q [:<cmd>qa<CR> :Fechar]
                  :s ["<cmd>Telescope symbols<CR>" "Inserir símbolo"]
                  :t [:<cmd>Mason<CR> "Ferramentas (Mason)"]
                  :u [:<cmd>PackerSync<CR> "Atualizar plugins"]}
              :g {:name :Git
                  :b {:name :Blame
                      :a ["<cmd>Git blame<CR> " "Todos (all)"]
                      :b :Linha}
                  :c ["<cmd>Git commit<CR> " :Commit]
                  :d ["<cmd>Gdiff<CR> " :Diff]
                  :g ["<cmd>G log<CR>" :Log]
                  :h {:name :Hunks :u "Desfazer (undo)" :v :Ver}
                  :i {:name "Issues (Github)"
                      :c ["<cmd>Octo issue create<CR>" :Criar]
                      :l ["<cmd>Octo issue list<CR>" :Listar]}
                  :k [#(functions.checkout-new-branch)
                      "Criar branch e fazer checkout"]
                  :l ["<cmd>Git pull --rebase<CR> " :Pull]
                  :o ["<cmd>Octo actions<CR>" "Octo (ações do GitHub)"]
                  :p ["<cmd>Git -c push.default=current push<CR>" :Push]
                  :r ["<cmd>lua require'telescope.builtin'.git_branches()<CR>"
                      "Listar branches"]
                  :s ["<cmd>Git<CR> " :Status]
                  :u {:name "Pull Requests (Github)"
                      :c ["<cmd>Octo pr create<CR>" :Criar]
                      :l ["<cmd>Octo pr list<CR>" :Listar]}
                  :w ["<cmd>Gwrite<CR> " "Salvar e adicionar ao stage"]
                  :y [#(functions.lazygit-toggle) "Abrir lazygit"]}
              :h ["<cmd>split<CR> " "Dividir horizontalmente"]
              :i ["mpgg=G`p" "Indentar arquivo"]
              :l [#(functions.toggle-location-list) "Alternar locationlist"]
              :m {:name :Markdown
                  :m [:<cmd>Glow<CR> "Pré-visualizar com glow"]
                  :b [:<cmd>MarkdownPreview<CR>
                      "Pré-visualizar com navegador (browser)"]}
              :o {:name "Abrir arquivos do vim"
                  :i ["<cmd>exe 'edit' stdpath('config').'/init.vim'<CR>"
                      :init.vim]
                  :p ["<cmd>exe 'edit' stdpath('config').'/lua/plugins.lua'<CR>"
                      :plugins.lua]
                  :u {:name "Arquivos do usuário"
                      :i ["<cmd>exe 'edit' stdpath('config').'/lua/user/init.lua'<CR>"
                          "init.lua do usuário"]
                      :p ["<cmd>exe 'edit' stdpath('config').'/lua/user/plugins.lua'<CR>"
                          "plugins.lua do usuário"]}
                  :s ["<cmd>exe 'source' stdpath('config').'/init.lua'<CR>"
                      "Atualizar (source) configurações do vim"]}
              :p {:name :Projeto
                  :e ["<cmd>lua require'telescope.builtin'.grep_string()<CR>"
                      "Procurar texto sob cursor"]
                  :f ["<cmd>lua require'telescope.builtin'.find_files()<CR>"
                      "Buscar (find) arquivo"]
                  :p ["<cmd>Telescope projects<CR>" :Listar]
                  :s ["<cmd>lua require'telescope.builtin'.grep_string({ search = vim.fn.input('Grep For> ')})<CR>"
                      "Procurar (search) nos arquivos"]}
              :q [#(functions.toggle-quickfix) "Alternar quickfix"]
              :s {:name "Sessão"
                  :c [:<cmd>SessionLoad<CR> :Carregar]
                  :l [#(functions.session-list) :Listar]
                  :s [:<cmd>SessionSave<CR> :Salvar]}
              :t ["<cmd>exe v:count1 . \"ToggleTerm\"<CR>" :Terminal]
              :v [:<cmd>vsplit<CR> "Dividir verticalmente"]
              :w {:name :Window :c [:<c-w>c "Fechar janela"]}}
             (vim.tbl_extend :force options {:mode :n :prefix :<leader>}))

; Mapeamentos do pounce
(map! [n] :s :<cmd>Pounce<CR>)

; Toda a vez que pular para próxima palavra buscada o cursor fica no centro da tela
(map! [n :nowait] :n :nzzzv)
(map! [n :nowait] :N :Nzzzv)

; Explorador de arquivos
(map! [n] :<F3> :<cmd>NvimTreeToggle<CR>)
(map! [n] :<F2> :<cmd>NvimTreeFindFile<CR>)

; Mover cursor para outra janela divida
(map! [n] :<C-j> :<C-w>j)
(map! [n] :<C-k> :<C-w>k)
(map! [n] :<C-l> :<C-w>l)
(map! [n] :<C-h> :<C-w>h)

; Limpar espaços em branco nos finais da linha
(map! [n] :<F5> "mp<cmd>%s/\\s\\+$/<CR>`p")

; Enter no modo normal funciona como no modo inserção
(map! [n] :<CR> :i<CR><Esc>)

; Setas redimensionam janelas adjacentes
(map! [n] :<left> "<cmd>vertical resize -5<cr>")
(map! [n] :<right> "<cmd>vertical resize +5<cr>")
(map! [n] :<up> "<cmd>resize -5<cr>")
(map! [n] :<down> "<cmd>resize +5<cr>")

; Mover de forma natural em wrap
(map! [n :expr] :k "v:count == 0 ? 'gk' : 'k'")
(map! [n :expr] :j "v:count == 0 ? 'gj' : 'j'")

; Manter seleção depois de indentação
(map! [v] "<" :<gv)
(map! [v] ">" :>gv)

; Mover linhas
(map! [v] :K ":m '<-2<CR>gv=gv")
(map! [v] :J ":m '>+1<CR>gv=gv")

(map! [n] :K #(vim.lsp.buf.hover))

(wk.register {:i [#(vim.lsp.buf.implementation) "Implementação"]
              :r ["<cmd>lua require'telescope.builtin'.lsp_references()<CR>"
                  "Referências"]
              :y ["<cmd>lua require'telescope.builtin'.lsp_type_definitions()<CR>"
                  "Definição do tipo"]}
             (vim.tbl_extend :force options {:mode :n :prefix :g}))

(vim.cmd ":iab ,\\ λ")
(map! [nivcx :remap] :<c-m> :<CR>)
