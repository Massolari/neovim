(require-macros :hibiscus.vim)
(require-macros :hibiscus.packer)

(exec [[:packadd :matchit]])

(packer-setup)

(packer (use :udayvir-singh/tangerine.nvim) ; Suporte à fennel
        (use :udayvir-singh/hibiscus.nvim) ; Macros para fennel
        (use :kyazdani42/nvim-web-devicons) ; Ícones
        (use :gpanders/editorconfig.nvim) ; Editorconfig
        (use :xolox/vim-misc)
        (use! :xolox/vim-session :requires :xolox/vim-misc) ; Sessões
        (use! :nvim-telescope/telescope.nvim ; Buscador
              :requires :nvim-lua/plenary.nvim :config
              (fn []
                (let [telescope (require :telescope)
                      actions (require :telescope.actions)]
                  (telescope.setup {:defaults {:mappings {:i {:<c-j> actions.move_selection_next
                                                              :<c-k> actions.move_selection_previous
                                                              :<esc> actions.close}}}})
                  (telescope.load_extension :fzf)
                  (telescope.load_extension :coc))))
        (use! :nvim-telescope/telescope-fzf-native.nvim :run :make)
        (use :fannheyward/telescope-coc.nvim)
        (use! :nvim-treesitter/nvim-treesitter
              ; Sintasse para várias linguagens
              :run ":TSUpdate")
        (use! :numToStr/Comment.nvim ; Comentário de forma fácil
              :config #(let [c (require :Comment)]
                        (c.setup {})))
        (use! :mattn/emmet-vim ; Habilita o uso do emmet (<C-g>,)
              :config (fn [] ; Usar o emmet apenas no modo visual ou no modo inserção
                       (g! user_emmet_mode :iv)
                       (g! user_emmet_leader_key :<C-g>)))
        (use! :rlane/pounce.nvim ; Habilita a busca rapida usando duas letras
              :config #(let [p (require :pounce)]
                        (p.setup {}))) (use :ellisonleao/gruvbox.nvim)
        ; Temas
        (use :projekt0n/github-nvim-theme)
        (use! :lewis6991/gitsigns.nvim
              ; Mostra um git diff na coluna de número e comandos para hunks
              :requires :nvim-lua/plenary.nvim :config
              #(let [g (require :gitsigns)]
                 (g.setup {:numhl false
                           :linehl false
                           :on_attach (fn [bufnr]
                                        (let [gs (require :gitsigns)]
                                          (map! [n :expr :buffer] "]c"
                                                #(if vim.wo.diff "]c"
                                                     (do
                                                       (vim.schedule #(gs.next_hunk))
                                                       :<Ignore>)))
                                          (map! [n :expr :buffer] "[c"
                                                #(if vim.wo.diff "[c"
                                                     (do
                                                       (vim.schedule #(gs.prev_hunk))
                                                       :<Ignore>)))
                                          (map! [n :buffer] :<leader>ghu
                                                `gs.reset_hunk)
                                          (map! [v :buffer] :<leader>ghu
                                                #(gs.reset_hunk [(vim.fn.line ".")
                                                                 (vim.fn.line :v)]))
                                          (map! [n :buffer] :<leader>ghv
                                                `gs.preview_hunk)
                                          (map! [n :buffer] :<leader>gbb
                                                #(gs.blame_line {:full true}))))
                           :current_line_blame true
                           :current_line_blame_opts {:delay 0}})))
        (use! :lukas-reineke/indent-blankline.nvim
              ; Mostra linhas de indentação
              :config
              #(let [i (require :indent_blankline)]
                 (i.setup {:show_current_context true})))
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
        (use! :tpope/vim-fugitive ; Warper para comandos do git
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
              :config
              #(let [k (require :which-key)]
                 (k.setup {:plugins {:spelling {:enabled true}
                                     :presets {:operators false}}})))
        (use! :diepm/vim-rest-console :opt true :ft :rest) ; Cliente REST
        (use! :neoclide/coc.nvim :branch :release) ; LSP
        (use! :akinsho/nvim-toggleterm.lua ; Alternador de terminal
              :config
              #(let [t (require :toggleterm)]
                 (t.setup {:shade_terminals false
                           :direction :horizontal
                           :insert_mappings false
                           :terminal_mappings false})))
        (use! :akinsho/bufferline.nvim ; Buffers no topo como abas
              :requires :kyazdani42/nvim-web-devicons :config
              #(let [b (require :bufferline)]
                 (b.setup {:options {:diagnostics :coc
                                     :diagnostics_indicator (fn [_
                                                                 _
                                                                 diagnostics_dict
                                                                 _]
                                                              (let [diagnostics {:error ""
                                                                                 :warning ""
                                                                                 :hint ""
                                                                                 :info ""}
                                                                    get-icon #(match $1
                                                                                :error "  "
                                                                                :warning "  "
                                                                                :hint "  "
                                                                                :info "  ")]
                                                                (each [e n (pairs diagnostics_dict)]
                                                                  (tset diagnostics
                                                                        e
                                                                        (.. (get-icon e)
                                                                            n)))
                                                                (.. diagnostics.error
                                                                    diagnostics.warning
                                                                    diagnostics.hint
                                                                    diagnostics.info)))}})))
        (use :github/copilot.vim) ; Copiloto
        (use :antoinemadec/FixCursorHold.nvim) ; Correção do CursorHold
        (use! :norcalli/nvim-colorizer.lua ; Colorir hexademical de cores
              :config #(let [c (require :colorizer)]
                        (c.setup {1 "*"
                                  :css {:hsl_fn true}
                                  :scss {:hsl_fn true}})))
        (use :ChristianChiarulli/dashboard-nvim) ; Dashboard
        (use :gelguy/wilder.nvim) ; Wildmenu melhorado
        (use :ellisonleao/glow.nvim) ; Pré-visualizar markdown
        (use! :RishabhRD/nvim-cheat.sh ; Procurar em cheat.sh
              :requires :RishabhRD/popfix)
        (use :protex/better-digraphs.nvim) ; Dígrafos
        (use :rcarriga/nvim-notify) ; Notificações mais bonitas
        (use! :mg979/vim-visual-multi ; Múltiplos cursores
              :branch :master)
        (local {: file-exists?} (require :functions))
        (let [user-file (.. (vim.fn.stdpath :config) :/lua/user/plugins.lua)]
          (when (file-exists? user-file)
            (let [u (require :user.plugins)]
              (u.setup use)))))
