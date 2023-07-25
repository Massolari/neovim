(import-macros {: g!} :hibiscus.vim)
(local {: require-and : prefixed-keys} (require :functions))

(local plugins
       [;; Fennel
        {1 :udayvir-singh/tangerine.nvim :priority 1001 :lazy false}
        :udayvir-singh/hibiscus.nvim
        {1 :Olical/conjure
         :dependencies [:Olical/aniseed]
         :ft :fennel
         :init #(g! "conjure#mapping#doc_word" :K)}
        {1 :unblevable/quick-scope :event :VeryLazy}
        ;; Temas
        {1 :projekt0n/github-nvim-theme :lazy true :branch :0.0.x}
        {1 :maxmx03/solarized.nvim
         :lazy false
         :priority 1000
         :config (fn []
                   (require-and :solarized
                               #($.setup {:theme :neo
                                          :highlights (fn [colors {: lighten}]
                                                        {:IndentBlanklineChar {:fg (lighten colors.base01
                                                                                            50)}
                                                         :IndentBlanklineContextChar {:fg colors.base01}})})))}
        {1 :ellisonleao/gruvbox.nvim
         :lazy true
         :init (fn []
                 (g! :gruvbox_italic 1)
                 (g! :gruvbox_sign_column :bg0))}
        ;; Interface
        ; Linhas de identação
        {1 :lukas-reineke/indent-blankline.nvim
         :enabled false
         :event :BufReadPre
         :opts {:show_current_context true}
         :init #(g! :indent_blankline_filetype_exclude
                    [:dashboard :lsp-installer ""])}
        ; Erros na linha abaixo
        {:url "https://git.sr.ht/~whynothugo/lsp_lines.nvim"
         :event :BufReadPost
         :config true}
        ; Destaque na palavra sob o cursor
        {1 :RRethy/vim-illuminate :event :BufReadPost}
        {1 :windwp/nvim-autopairs :event :InsertEnter :config true}
        ;; Outros
        ; Comentar código
        {1 :numToStr/Comment.nvim :config true :keys [:gc {1 :gc :mode :v}]}
        ; Emmet
        {1 :mattn/emmet-vim
         :keys [{1 "<C-g>," :mode :i}]
         :init (fn []
                 (g! :user_emmet_mode :iv)
                 (g! :user_emmet_leader_key :<C-g>))}
        ; Ações com pares
        {1 :kylechui/nvim-surround :event :VeryLazy :config true}
        ; Objetos de texto adicionais
        {1 :wellle/targets.vim :event :VeryLazy}
        ; Explorador de arquivos
        {1 :kyazdani42/nvim-tree.lua
         :dependencies [:kyazdani42/nvim-web-devicons]
         :opts {:git {:ignore false}}
         :keys [[:<F3> :<cmd>NvimTreeToggle<CR>]
                [:<F2> :<cmd>NvimTreeFindFile<CR>]]}
        ; Animais andando pelo código
        {1 :tamton-aquib/duck.nvim :lazy true}
        ; Usar Neovim em campos de text do navegador
        {1 :glacambre/firenvim
         :cond (not (not vim.g.started_by_firenvim))
         :build (fn []
                  (require-and :lazy #($.load {:plugins :firenvim :wait true}))
                  (vim.fn.firenvim#install 0))
         :init (fn []
                 (set vim.g.firenvim_config
                      {:localSettings {:.* {:takeover :never}}}))}
        ; ChatGPT
        {1 :jackMort/ChatGPT.nvim
         :enabled false
         :dependencies [:MunifTanjim/nui.nvim
                        :nvim-lua/plenary.nvim
                        :nvim-telescope/telescope.nvim]
         :keys (prefixed-keys [{1 :a
                                2 :<cmd>ChatGPTActAs<CR>
                                :desc "Agir como..."}
                               {1 :c 2 :<cmd>ChatGPT<CR> :desc :Abrir}
                               {1 :e
                                2 :<cmd>ChatGPTEditWithInstructions<CR>
                                :desc "Editar com instruções"
                                :mode :v}]
                              :<leader>ec)
         :opts {:keymaps {:submit :<CR>}}
         :config true}
        ; Verificador de gramática
        {1 :brymer-meneses/grammar-guard.nvim
         :event :BufReadPost
         :dependencies [:neovim/nvim-lspconfig :williamboman/mason.nvim]
         :config #(require-and :grammar-guard #($.init))}
        {1 :uga-rosa/utf8.nvim :lazy true}
        ; Instalador de ferramentas de código
        {1 :williamboman/mason.nvim
         :cmd :Mason
         :config true
         :keys [{1 :<leader>et 2 :<cmd>Mason<CR> :desc "Ferramentas (Mason)"}]}
        ; Funcionalidades para a linguagem Nim
        {1 :alaviss/nim.nvim :ft :nim}
        ; Procurar e substituir no projeto
        {1 :windwp/nvim-spectre
         :dependencies [:nvim-lua/plenary.nvim]
         :keys [{1 :<leader>es
                 2 #(require-and :spectre #($.open))
                 :desc "Procurar e substituir"}]
         :config true}
        ; Markdown preview
        {1 :iamcco/markdown-preview.nvim
         :build #(vim.fn.mkdp#util#install)
         :ft :markdown
         :keys [{1 :<leader>em
                 2 :<cmd>MarkdownPreview<CR>
                 :desc "Markdown preview"}]}
        {1 :roobert/tailwindcss-colorizer-cmp.nvim}
        {1 :Massolari/web.nvim
         :dir (.. vim.env.HOME :/nvim-web-browser)
         :dependencies [:nvim-lua/plenary.nvim]}
        ; Forem
        {1 :Massolari/forem.nvim
         :dir (.. vim.env.HOME :/forem.nvim)
         :cmd :Forem
         :config true
         :dependencies [:nvim-lua/plenary.nvim :nvim-telescope/telescope.nvim]}])

(let [(_ user-plugins) (xpcall #(require :user.plugins)
                               (fn []
                                 []))]
  (each [_ user-plugin (pairs user-plugins)]
    (table.insert plugins user-plugin)))

plugins
