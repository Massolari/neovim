(require-macros :hibiscus.vim)
(require-macros :hibiscus.packer)

(exec [[:packadd :matchit]])

(packer-setup)

(packer (use :udayvir-singh/tangerine.nvim) ; Suporte à fennel
        (use :udayvir-singh/hibiscus.nvim) ; Macros para fennel
        (use :kyazdani42/nvim-web-devicons) ; Ícones
        (use :gpanders/editorconfig.nvim) ; Editorconfig
        (use :xolox/vim-misc)
        (use! :xolox/vim-session ; Sessões
              :requires :xolox/vim-misc :config #(require :plugins.vim-session))
        (use! :nvim-telescope/telescope.nvim ; Buscador
              :requires [:nvim-lua/plenary.nvim
                        :nvim-telescope/telescope-fzf-native.nvim
                        :fannheyward/telescope-coc.nvim]
              :config #(require :plugins.telescope))
        (use! :nvim-telescope/telescope-fzf-native.nvim :run :make)
        (use :fannheyward/telescope-coc.nvim)
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
        (use :shaunsingh/solarized.nvim) (use :ishan9299/nvim-solarized-lua)
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
        (use! :neoclide/coc.nvim :branch :release) ; LSP
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
        (use! :gelguy/wilder.nvim :config #(require :plugins.wilder))
        ; Wildmenu melhorado
        (use :ellisonleao/glow.nvim) ; Pré-visualizar markdown
        (use! :RishabhRD/nvim-cheat.sh ; Procurar em cheat.sh
              :requires :RishabhRD/popfix)
        (use :protex/better-digraphs.nvim) ; Dígrafos
        (use! :rcarriga/nvim-notify :config #(require :plugins.nvim-notify))
        ; Notificações mais bonitas
        (use! :mg979/vim-visual-multi ; Múltiplos cursores
              :branch :master)
        ;; (use! :/Users/douglasmassolari/forem.nvim ; Integração com Forem
        (use! :Massolari/forem.nvim ; Integração com Forem
              :config #(require :plugins.forem))
        (local {: file-exists?} (require :functions))
        (let [user-file (.. (vim.fn.stdpath :config) :/lua/user/plugins.lua)]
          (when (file-exists? user-file)
            (let [u (require :user.plugins)]
              (u.setup use)))))
