(local wk (require :which-key))

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
(vim.keymap.set :n :U :<c-r> {:desc "Refazer"})

; Normal com leader
(keymaps-set :n
             [["," "mpA,<Esc>`p" {:desc "\",\" no fim da linha"}]
              [";" "mpA;<Esc>`p" {:desc "\";\" no fim da linha"}]
              [:<Tab> "\030" {:desc "Alterar para arquivo anterior"}]
              ["=" :<c-w>= {:desc "Igualar tamanho das janelas"}]
              ["%" :ggVG {:desc "Selecionar tudo"}]
              [:d "<cmd>bn|bd #<CR>" {:desc "Deletar buffer"}]
              [:D :<cmd>bd<CR> {:desc "Deletar buffer e fechar janela"}]
              [:h :<cmd>split<CR> {:desc "Dividir horizontalmente"}]
              [:i "mpgg=G`p" {:desc "Indentar arquivo"}]
              [:l
               #(functions.toggle-location-list)
               {:desc "Alternar locationlist"}]
              [:n :<cmd>noh<cr> {:desc "Limpar seleção da pesquisa"}]
              [:on
               #(let [vaults (-> (.. "^ls '" vim.g.obsidian_dir "'")
                                 (vim.fn.system)
                                 (vim.fn.split "\n"))]
                  (vim.ui.select vaults {:prompt "Cofre para novo arquivo"}
                                 (fn [vault]
                                   (functions.with-input "Novo arquivo: "
                                     (fn [name]
                                       (when (not= name "")
                                         (vim.cmd.e (.. vim.g.obsidian_dir "/"
                                                        vault "/" name))))))))
               {:desc "Novo arquivo"}]
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
                 [:d :<cmd>DevdocsOpen<CR> {:desc :Devdocs}]
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

(wk.add [{1 :<leader>a :group :Aba}
         {1 :<leader>b :group :Buffer}
         {1 :<leader>c :group :Code}
         {1 :<leader>d :group :Debug}
         {1 :<leader>e :group :Editor}
         {1 :<leader>eh :group "Cliente HTTP"}
         {1 :<leader>g :group :Git}
         {1 :<leader>gb :group :Blame}
         {1 :<leader>gh :group :Hunks}
         {1 :<leader>gi :group "Issues (Github)"}
         {1 :<leader>gu :group "Pull Requests (Github)"}
         {1 :<leader>o :group :Obsidian}
         {1 :<leader>p :group :Projeto}
         {1 :<leader>w :proxy :<c-w> :group :Window}])

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

