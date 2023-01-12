(local {: requireAnd : has-files-dirs?} (require :functions))

[;; Fennel
 :udayvir-singh/tangerine.nvim
 :udayvir-singh/hibiscus.nvim
 {1 :gpanders/editorconfig.nvim
  :event :BufReadPost
  :cond #(has-files-dirs? [:.editorconfig])}
 {1 :Olical/conjure :ft :fennel}
 {1 :rlane/pounce.nvim :config true :cmd :Pounce}
 {1 :unblevable/quick-scope :event :VeryLazy}
 ;; Temas
 {1 :ellisonleao/gruvbox.nvim :lazy true}
 :projekt0n/github-nvim-theme
 ;; Git
 {1 :tpope/vim-fugitive :cmd [:G :Git :Gdiff :Gclog :Gwrite]}
 ;; Interface
 ; Linhas de identação
 {1 :lukas-reineke/indent-blankline.nvim
  :event :BufReadPre
  :opts {:show_current_context true}}
 ; Barra de status
 {1 :nvim-lualine/lualine.nvim :dependencies [:kyazdani42/nvim-web-devicons]}
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
 {1 :numToStr/Comment.nvim :config true :keys [:gc {1 :gc :mode :v}]}
 ; Emmet
 {1 :mattn/emmet-vim :keys [{1 "<C-g>," :mode :i}]}
 ; Ações com pares
 {1 :kylechui/nvim-surround :event :VeryLazy :config true}
 ; Objetos de texto adicionais
 {1 :wellle/targets.vim :event :VeryLazy}
 ; Explorador de arquivos
 {1 :kyazdani42/nvim-tree.lua
  :dependencies [:kyazdani42/nvim-web-devicons]
  :cmd [:NvimTreeToggle :NvimTreeFindFile]}
  :opts {:disable_netrw false}
 ; Múltiplos cursores
 {1 :mg979/vim-visual-multi :keys [:<c-g> :<c-t>] :branch :master}
 ; Animais andando pelo código
 {1 :tamton-aquib/duck.nvim :lazy true}
 ; Usar Neovim em campos de text do navegador
 {1 :glacambre/firenvim :event :VeryLazy :build #(vim.fn.firenvim#install 0)}
 ; Verificador de gramática
 {1 :brymer-meneses/grammar-guard.nvim
  :event :BufReadPost
  :dependencies [:neovim/nvim-lspconfig :williamboman/mason.nvim]
  :config #(requireAnd :grammar-guard #($.init))}
 ; Funcionalidades para a linguagem Nim
 {1 :alaviss/nim.nvim :ft :nim}]
