(require-macros :hibiscus.vim)
(require-macros :hibiscus.packer)

(exec [[:packadd :matchit]])

(packer-setup)

(packer (use :udayvir-singh/tangerine.nvim) ; Suporte à fennel
        (use :udayvir-singh/hibiscus.nvim) ; Macros para fennel
        (use :Olical/conjure) (use :kyazdani42/nvim-web-devicons) ; Ícones
        (use :gpanders/editorconfig.nvim) ; Editorconfig
        (use :xolox/vim-misc)
        (use! :xolox/vim-session ; Sessões
              :requires :xolox/vim-misc :config #(require :plugins.vim-session))
        (use! :nvim-telescope/telescope.nvim ; Buscador
              :requires
              [:nvim-lua/plenary.nvim
               :nvim-telescope/telescope-fzf-native.nvim
               :nvim-telescope/telescope-ui-select.nvim
               :ahmedkhalf/project.nvim
               :nvim-telescope/telescope-symbols.nvim] :config
              #(require :plugins.telescope))
        (use! :nvim-telescope/telescope-fzf-native.nvim :run :make)
        (use :nvim-telescope/telescope-symbols.nvim)
        (use :nvim-telescope/telescope-ui-select.nvim)
        (use! :ahmedkhalf/project.nvim :config
              #(let [p (require :project_nvim)]
                 (p.setup {})))
        (use! :nvim-treesitter/nvim-treesitter
              ; Sintasse para várias linguagens
              :run ":TSUpdate" :config #(require :plugins.treesitter))
        (use! :numToStr/Comment.nvim ; Comentário de forma fácil
              :config #(let [c (require :Comment)]
                        (c.setup {})))
        (use! :mattn/emmet-vim ; Habilita o uso do emmet (<C-g>,)
              :config #(require :plugins.emmet))
        (use! :rlane/pounce.nvim ; Habilita a busca rapida usando duas letras
              :config #(let [p (require :pounce)]
                        (p.setup {}))) ;
        ; Temas
        (use :ellisonleao/gruvbox.nvim) (use :projekt0n/github-nvim-theme)
        (use :catppuccin/nvim) (use :shaunsingh/solarized.nvim)
        (use :rafi/awesome-vim-colorschemes) (use :nlknguyen/papercolor-theme)
        (use :ishan9299/nvim-solarized-lua)
        (use! :lewis6991/gitsigns.nvim
              ; Mostra um git diff na coluna de número e comandos para hunks
              :requires :nvim-lua/plenary.nvim :config
              #(require :plugins.gitsigns))
        (use! :lukas-reineke/indent-blankline.nvim
              ; Mostra linhas de indentação
              :config #(require :plugins.indent-blankline))
        (use! :windwp/nvim-autopairs ; Auto-fechamento de delimitadores
              :config #(let [a (require :nvim-autopairs)]
                        (a.setup {}))) (use :tpope/vim-surround)
        ; Operação com delimitadores
        (use :unblevable/quick-scope) ; Se mover melhor com o f/t
        (use :wellle/targets.vim) ; Text-objects melhorados e com seek
        (use! :kyazdani42/nvim-tree.lua ; Explorador de arquivos
              :requires :kyazdani42/nvim-web-devicons :config
              #(let [t (require :nvim-tree)]
                 (t.setup {:disable_netrw false})))
        (use! :tpope/vim-fugitive ; Wrapper para comandos do git
              :opt true :cmd [:G :Git :Gdiff :Gclog :Gwrite])
        (use! :pwntester/octo.nvim ; Comandos do github
              :requires [:nvim-lua/plenary.nvim
                        :nvim-telescope/telescope.nvim
                        :kyazdani42/nvim-web-devicons]
              :config #(let [o (require :octo)]
                        (o.setup {})))
        (use :rafamadriz/friendly-snippets) ; Biblioteca de snippets
        (use! :nvim-lualine/lualine.nvim ; Status line
              :requires {1 :kyazdani42/nvim-web-devicons :opt true})
        (use! :folke/which-key.nvim ; Guia de atalhos
              :config #(require :plugins.which-key))
        (use! :diepm/vim-rest-console ; Cliente REST
              :opt true :ft :rest :config #(require :plugins.vim-rest-console))
        (use! :neovim/nvim-lspconfig :requires
              [:williamboman/mason.nvim
               :williamboman/mason-lspconfig.nvim
               :j-hui/fidget.nvim
               :nvim-lua/lsp-status.nvim] :config
              #(require :plugins.lsp)) ; LSP
        (use! :jose-elias-alvarez/null-ls.nvim :requires :nvim-lua/plenary.nvim
              :config #(require :plugins.null-ls))
        (use :williamboman/mason.nvim) (use :williamboman/mason-lspconfig.nvim)
        (use! :j-hui/fidget.nvim ; Fidget
              :config #(let [f (require :fidget)]
                        (f.setup {:text {:spinner :moon :done "🌝"}}))) ; Fidget
        (use :nvim-lua/lsp-status.nvim)
        (use! :hrsh7th/nvim-cmp ;; Autocomplete
              :requires [:hrsh7th/cmp-nvim-lsp
                        :PaterJason/cmp-conjure
                        :hrsh7th/cmp-buffer
                        :hrsh7th/cmp-path
                        :L3MON4D3/LuaSnip
                        :saadparwaiz1/cmp_luasnip
                        :onsails/lspkind.nvim
                        :hrsh7th/cmp-calc
                        :hrsh7th/cmp-emoji
                        :hrsh7th/cmp-cmdline] ;
              :config #(require :plugins.cmp))
        (use! "https://git.sr.ht/~whynothugo/lsp_lines.nvim"
              ;; Diagnostic inline
              :config #(let [l (require :lsp_lines)]
                        (l.setup))) ; LSP lines
        (use :L3MON4D3/LuaSnip)
        (use! :akinsho/nvim-toggleterm.lua ; Alternador de terminal
              :config #(require :plugins.nvim-toggleterm))
        (use! :akinsho/bufferline.nvim ; Buffers no topo como abas
              :requires :kyazdani42/nvim-web-devicons :config
              #(require :plugins.bufferline)) (use :github/copilot.vim)
        ; Copiloto
        (use :antoinemadec/FixCursorHold.nvim) ; Correção do CursorHold
        (use! :norcalli/nvim-colorizer.lua ; Colorir hexademical de cores
              :config #(require :plugins.nvim-colorizer))
        (use! :ChristianChiarulli/dashboard-nvim ; Dashboard
              :config #(require :plugins.dashboard))
        (use! :ellisonleao/glow.nvim :config
              #(let [g (require :glow)]
                 (g.setup {:style (vim.opt.background:get)})))
        ; Pré-visualizar markdown
        (use! :RishabhRD/nvim-cheat.sh ; Procurar em cheat.sh
              :requires :RishabhRD/popfix)
        (use :protex/better-digraphs.nvim) ; Dígrafos
        (use! :rcarriga/nvim-notify :config #(require :plugins.nvim-notify))
        ; Notificações mais bonitas
        (use! :mg979/vim-visual-multi ; Múltiplos cursores
              :branch :master)
        (use! :/Users/douglasmassolari/forem.nvim ; Integração com Forem
              ;; (use! :Massolari/forem.nvim ; Integração com Forem
              :config #(require :plugins.forem))
        (use :RRethy/vim-illuminate)
        (local {: file-exists?} (require :functions))
        (let [user-file (.. (vim.fn.stdpath :config) :/lua/user/plugins.lua)]
          (when (file-exists? user-file)
            (let [u (require :user.plugins)]
              (u.setup use)))))
