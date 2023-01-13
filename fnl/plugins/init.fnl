(local {: requireAnd : has-files-dirs?} (require :functions))

(λ prefixed-keys [mappings prefix]
  (icollect [_ {1 keys 2 cmd &as map-options} (ipairs mappings)]
    (vim.tbl_extend :keep [(.. prefix keys) cmd] map-options)))

(local plugins [;; Fennel
                {1 :udayvir-singh/tangerine.nvim :priority 1001 :lazy false}
                :udayvir-singh/hibiscus.nvim
                {1 :gpanders/editorconfig.nvim
                 :event :BufReadPost
                 :cond #(has-files-dirs? [:.editorconfig])}
                {1 :Olical/conjure :ft :fennel}
                {1 :rlane/pounce.nvim
                 :config true
                 :keys [[:s :<cmd>Pounce<CR>]]}
                {1 :unblevable/quick-scope :event :VeryLazy}
                ;; Temas
                {1 :projekt0n/github-nvim-theme
                 :priority 1000
                 :config #(when (= nil vim.g.colors_name)
                            (vim.cmd.colorscheme :github_light))}
                {1 :ellisonleao/gruvbox.nvim :lazy true}
                ;; Git
                {1 :tpope/vim-fugitive
                 :cmd [:G :Git]
                 :keys (prefixed-keys [{1 :ba
                                        2 "<cmd>Git blame<CR>"
                                        :desc "Todos (all)"}
                                       {1 :c
                                        2 "<cmd>Git commit<CR>"
                                        :desc :Commit}
                                       {1 :d 2 :<cmd>Gdiff<CR> :desc :Diff}
                                       {1 :g 2 "<cmd>G log<CR>" :desc :Log}
                                       {1 :l
                                        2 "<cmd>Git pull --rebase<CR> "
                                        :desc :Pull}
                                       {1 :p
                                        2 "<cmd>Git -c push.default=current push<CR>"
                                        :desc :Push}
                                       {1 :s 2 :<cmd>Git<CR> :desc :Status}
                                       {1 :w
                                        2 :<cmd>Gwrite<CR>
                                        :desc "Salvar e adicionar ao stage"}]
                                      :<leader>g)}
                ;; Interface
                ; Linhas de identação
                {1 :lukas-reineke/indent-blankline.nvim
                 :event :BufReadPre
                 :opts {:show_current_context true}}
                ; Barra de status
                {1 :nvim-lualine/lualine.nvim
                 :dependencies [:kyazdani42/nvim-web-devicons]}
                ; Erros na linha abaixo
                {:url "https://git.sr.ht/~whynothugo/lsp_lines.nvim"
                 :event :BufReadPost
                 :config true}
                ; Destaque na palavra sob o cursor
                {1 :RRethy/vim-illuminate :event :BufReadPost}
                ;; Autocompletar
                {1 :github/copilot.vim :event :InsertEnter}
                {1 :windwp/nvim-autopairs :event :InsertEnter :config true}
                ;; Outros
                ; Comentar código
                {1 :numToStr/Comment.nvim
                 :config true
                 :keys [:gc {1 :gc :mode :v}]}
                ; Emmet
                {1 :mattn/emmet-vim :keys [{1 "<C-g>," :mode :i}]}
                ; Ações com pares
                {1 :kylechui/nvim-surround :event :VeryLazy :config true}
                ; Objetos de texto adicionais
                {1 :wellle/targets.vim :event :VeryLazy}
                ; Explorador de arquivos
                {1 :kyazdani42/nvim-tree.lua
                 :dependencies [:kyazdani42/nvim-web-devicons]
                 :opts {:disable_netrw false}
                 :keys [[:<F3> :<cmd>NvimTreeToggle<CR>]
                        [:<F2> :<cmd>NvimTreeFindFile<CR>]]}
                ; Múltiplos cursores
                {1 :mg979/vim-visual-multi
                 :keys [:<c-g> :<c-t>]
                 :branch :master}
                ; Animais andando pelo código
                {1 :tamton-aquib/duck.nvim :lazy true}
                ; Usar Neovim em campos de text do navegador
                {1 :glacambre/firenvim
                 :event :VeryLazy
                 :build #(vim.fn.firenvim#install 0)}
                ; ChatGPT
                {1 :jackMort/ChatGPT.nvim
                 :dependencies [:MunifTanjim/nui.nvim
                                :nvim-lua/plenary.nvim
                                :nvim-telescope/telescope.nvim]
                 :keys (prefixed-keys [{1 :a
                                        2 :<cmd>ChatGPTActAs<CR>
                                        :desc "Agir como..."}
                                       {1 :c 2 :<cmd>ChatGPT<CR> :desc :Abrir}
                                       {1 :e
                                        2 :<cmd>ChatGPTEditWithInstructions<CR>
                                        :desc "Editar com instruções"}]
                                      :<leader>ec)
                 :config true}
                ; Verificador de gramática
                {1 :brymer-meneses/grammar-guard.nvim
                 :event :BufReadPost
                 :dependencies [:neovim/nvim-lspconfig
                                :williamboman/mason.nvim]
                 :config #(requireAnd :grammar-guard #($.init))}
                ; Funcionalidades para a linguagem Nim
                {1 :alaviss/nim.nvim :ft :nim}])

(local (_ user-plugins) (xpcall #(require :user.plugins)
                            (fn []
                              [])))

(vim.tbl_extend :force plugins user-plugins)
