(require-macros :hibiscus.vim)
(require-macros :hibiscus.packer)

(local {: file-exists?} (require :functions))

(exec [[:packadd :matchit]])

(packer-setup)

(fn setup [package config]
  "Faz o require e chama o setup com o valor de config"
  (#(let [p (require package)]
      (p.setup config))))

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
              :config (setup :Comment {}))
        (use! :mattn/emmet-vim ; Habilita o uso do emmet (<C-g>,)
              :config (fn [] ; Usar o emmet apenas no modo visual ou no modo inserção
                       (g! user_emmet_mode :iv)
                       (g! user_emmet_leader_key :<C-g>)))
        (use! :rlane/pounce.nvim ; Habilita a busca rapida usando duas letras
              :config (setup :pounce {}))
        (use :ellisonleao/gruvbox.nvim) ; Temas
        (use :projekt0n/github-nvim-theme)
        (use! :lewis6991/gitsigns.nvim
              ; Mostra um git diff na coluna de número e comandos para hunks
              :requires :nvim-lua/plenary.nvim :config
              (setup :gitsigns
                     {:numhl false
                      :linehl false
                      :keymaps {:noremap true
                                :buffer true
                                "n ]c" {:expr true
                                        1 "&diff ']c' '<cmd>lua require\"gitsigns.actions\".next_hunk()<CR>'"}
                                "n [c" {:expr true
                                        1 "&diff ? '[c' : '<cmd>lua require\"gitsigns.actions\".prev_hunk()<CR>'"}
                                "n <leader>ghu" "<cmd>lua require\"gitsigns\".reset_hunk()<CR>"
                                "v <leader>ghu" "<cmd>lua require\"gitsigns\".reset_hunk({vim.fn.line(\".\"), vim.fn.line(\"v\")})<CR>"
                                "n <leader>ghv" "<cmd>lua require\"gitsigns\".preview_hunk()<CR>"}
                      :current_line_blame true
                      :current_line_blame_opts {:delay 0}}))
        (use! :lukas-reineke/indent-blankline.nvim
              ; Mostra linhas de indentação
              :config (setup :indent_blankline {:show_current_context true}))
        (use! :windwp/nvim-autopairs ; Auto-fechamento de delimitadores
              :config (setup :nvim-autopairs {}))
        (use :tpope/vim-surround) ; Operação com delimitadores
        (use :unblevable/quick-scope) ; Se mover melhor com o f/t
        (use :wellle/targets.vim) ; Text-objects melhorados e com seek
        (use! :kyazdani42/nvim-tree.lua ; Explorador de arquivos
              :requires :kyazdani42/nvim-web-devicons :config
              (setup :nvim-tree {:disable_netrw false}))
        (use! :tpope/vim-fugitive ; Warper para comandos do git
              :opt true :cmd [:G :Git :Gdiff :Gclog :Gwrite])
        (use! :pwntester/octo.nvim ; Comandos do github
              :requires [:nvim-lua/plenary.nvim
                        :nvim-telescope/telescope.nvim
                        :kyazdani42/nvim-web-devicons]
              :config (setup :octo {}))
        (use :rafamadriz/friendly-snippets) ; Biblioteca de snippets
        (use! :nvim-lualine/lualine.nvim ; Status line
              :requires {1 :kyazdani42/nvim-web-devicons :opt true})
        (use! :folke/which-key.nvim ; Guia de atalhos
              :config (setup :which-key {:plugins {:spelling {:enabled true}}}))
        (use! :diepm/vim-rest-console :opt true :ft :rest) ; Cliente REST
        (use! :neoclide/coc.nvim :branch :release) ; LSP
        (use! :akinsho/nvim-toggleterm.lua ; Alternador de terminal
              :config (setup :toggleterm
                            {:shade_terminals false
                             :direction :horizontal
                             :insert_mappings false
                             :terminal_mappings false}))
        (use! :akinsho/bufferline.nvim ; Buffers no topo como abas
              :requires :kyazdani42/nvim-web-devicons :config
              (setup :bufferline
                     {:options {:diagnostics :coc
                                :diagnostics_indicator (fn [_
                                                            _
                                                            diagnostics_dict
                                                            _]
                                                         (let [diagnostics {:error ""
                                                                            :warning ""
                                                                            :hint ""
                                                                            :info ""}]
                                                           (each [e n (pairs diagnostics_dict)]
                                                             (if (= e :error)
                                                                 (set diagnostics.error
                                                                      (.. "  "
                                                                          n))
                                                                 (= e :warning)
                                                                 (set diagnostics.warning
                                                                      (.. "  "
                                                                          n))
                                                                 (= e :hint)
                                                                 (set diagnostics.hint
                                                                      (.. "  "
                                                                          n))
                                                                 (set diagnostics.info
                                                                      (.. "  "
                                                                          n))))
                                                           (.. diagnostics.error
                                                               diagnostics.warning
                                                               diagnostics.hint
                                                               diagnostics.info)))}}))
        (use :github/copilot.vim) ; Copiloto
        (use :antoinemadec/FixCursorHold.nvim) ; Correção do CursorHold
        (use! :norcalli/nvim-colorizer.lua ; Colorir hexademical de cores
              :config
              (setup :colorizer
                     {1 "*" :css {:hsl_fn true} :scss {:hsl_fn true}}))
        (use :ChristianChiarulli/dashboard-nvim) ; Dashboard
        (use :gelguy/wilder.nvim) ; Wildmenu melhorado
        (use! :mrjones2014/dash.nvim :run "make install")
        ; Integração com Dash (MacOS)
        (use :ellisonleao/glow.nvim) ; Pré-visualizar markdown
        (let [user-file (.. (vim.fn.stdpath :config) :/lua/user/plugins.lua)]
          (when (file-exists? user-file)
            (setup :user.plugins use))))
