(require-macros :hibiscus.vim)
(require-macros :hibiscus.packer)

(exec [[:packadd "matchit"]])

(packer-setup)

(fn setup [package config]
  "Faz o require e chama o setup com o valor de config"
  (#(let [p (require package)] (p.setup config))))

(packer
  ; Suporte à fennel
  (use :udayvir-singh/tangerine.nvim)
  (use :udayvir-singh/hibiscus.nvim)


  ; Ícones
  (use :kyazdani42/nvim-web-devicons)

  ; Editorconfig
  (use :editorconfig/editorconfig-vim)

  ; Sessões
  (use :xolox/vim-misc)
  (use! :xolox/vim-session
        :requires :xolox/vim-misc)

  ; Buscador
  (use! :nvim-telescope/telescope.nvim
        :requires :nvim-lua/plenary.nvim
        :config (fn []
          (let [telescope (require :telescope)
                actions (require :telescope.actions)]
            (telescope.setup
              {:defaults
               {:mappings
                {:i
                 {:<c-j> actions.move_selection_next
                  :<c-k> actions.move_selection_previous
                  :<esc> actions.close}}}})
            (telescope.load_extension "fzf")
            (telescope.load_extension "coc"))))

  (use! :nvim-telescope/telescope-fzf-native.nvim :run "make")
  (use :fannheyward/telescope-coc.nvim)

  ; Sintasse para várias linguagens
  (use! :nvim-treesitter/nvim-treesitter
        :run ":TSUpdate")

  ; Comentário de forma fácil
  (use! :numToStr/Comment.nvim
        :config (setup :Comment {}))

  ; Habilita o uso do emmet (<C-g>,)
  (use! :mattn/emmet-vim
        :config (fn []
          ; Usar o emmet apenas no modo visual ou no modo inserção
          (g! user_emmet_mode "iv")
          (g! user_emmet_leader_key "<C-g>")))

  ; Habilita a busca rapida usando duas letras
  (use! :rlane/pounce.nvim
        :config (setup :pounce {}))

  ; Temas
  (use :ellisonleao/gruvbox.nvim)
  (use :projekt0n/github-nvim-theme)


  ; Mostra um git diff na coluna de número e comandos para hunks
  (use! :lewis6991/gitsigns.nvim
        :requires :nvim-lua/plenary.nvim
        :config (setup :gitsigns
          {:numhl false
           :linehl false
           :keymaps
           {:noremap true
            :buffer true
            "n ]c" {:expr true 1 "&diff ']c' '<cmd>lua require\"gitsigns.actions\".next_hunk()<CR>'" }
            "n [c" {:expr true 1 "&diff ? '[c' : '<cmd>lua require\"gitsigns.actions\".prev_hunk()<CR>'" }

            "n <leader>ghu" "<cmd>lua require\"gitsigns\".reset_hunk()<CR>"
            "v <leader>ghu" "<cmd>lua require\"gitsigns\".reset_hunk({vim.fn.line(\".\"), vim.fn.line(\"v\")})<CR>"
            "n <leader>ghv" "<cmd>lua require\"gitsigns\".preview_hunk()<CR>"}
           :current_line_blame true
           :current_line_blame_opts {:delay 0}}))

  ; Mostra linhas de indentação
  (use! :lukas-reineke/indent-blankline.nvim
        :config (setup :indent_blankline {:show_current_context true}))

  ; Auto-fechamento de delimitadores
  (use! :windwp/nvim-autopairs
        :config (setup :nvim-autopairs {}))

  ; Operação com delimitadores
  (use :tpope/vim-surround)

  ; Se mover melhor com o f/t
  (use :unblevable/quick-scope)

  ; Text-objects melhorados e com seek
  (use :wellle/targets.vim)

  ; Explorador de arquivos
  (use! :kyazdani42/nvim-tree.lua
        :requires :kyazdani42/nvim-web-devicons
        :config (setup :nvim-tree {:disable_netrw false}))

  ; Warper para comandos do git
  (use! :tpope/vim-fugitive
        :opt true
        :cmd ["G" "Git" "Gdiff" "Gclog" "Gwrite"])
  (use! :pwntester/octo.nvim
        :requires
          [:nvim-lua/plenary.nvim
           :nvim-telescope/telescope.nvim
           :kyazdani42/nvim-web-devicons]
        :config (setup :octo {}))

  ; Biblioteca de snippets
  (use :rafamadriz/friendly-snippets)

  ; Status line
  (use! :nvim-lualine/lualine.nvim
        :requires { 1 :kyazdani42/nvim-web-devicons :opt true }
        :module "statusline")

  ; Guia de atalhos
  (use! :folke/which-key.nvim
        :config (setup :which-key
         {:plugins
          {:spelling
           {:enabled true}}}))

  ; Cliente REST
  (use! :diepm/vim-rest-console
        :opt true
        :ft "rest")

  ; LSP do Nvim
  (use! :neoclide/coc.nvim :branch "release")

  ; Alternador de terminal
  (use! :akinsho/nvim-toggleterm.lua
        :config (setup :toggleterm
          {:shade_terminals false
           :direction "horizontal"
           :insert_mappings false
           :terminal_mappings false}))

  ; Buffers no topo
  (use! :akinsho/bufferline.nvim
        :requires :kyazdani42/nvim-web-devicons
        :config (setup :bufferline
          {:options
           {:diagnostics "coc"
            :diagnostics_indicator (fn [_ _ diagnostics_dict _]
              (let [diagnostics {:error "" :warning "" :hint "" :info ""}]
                (each [e n (pairs diagnostics_dict)]
                  (if (= e "error")
                    (set diagnostics.error (.. "  " n))
                    (= e "warning")
                    (set diagnostics.warning (.. "  " n))
                    (= e "hint")
                    (set diagnostics.hint (.. "  " n))
                    (set diagnostics.info (.. "  " n))))
                (.. diagnostics.error diagnostics.warning diagnostics.hint diagnostics.info)))}}))

  ; Copiloto
  (use :github/copilot.vim)

  ; Correção do CursorHold
  (use :antoinemadec/FixCursorHold.nvim)

  ; Colorir hexademical de cores
  (use! :norcalli/nvim-colorizer.lua
        :config (setup :colorizer
          {1 :*
           :css {:hsl_fn true}
           :scss {:hsl_fn true}}))

  ; Dashboard
  (use :ChristianChiarulli/dashboard-nvim)

  ; Wildmenu melhorado
  (use :gelguy/wilder.nvim)

  ; Integração com Dash (MacOS)
  (use! :mrjones2014/dash.nvim
        :run "make install")

  ; Pré-visualizar markdown
  (use :ellisonleao/glow.nvim)

  (let [user-file (.. (vim.fn.stdpath "config") "/lua/user/plugins.lua")]
    (when (> (vim.fn.filereadable user-file) 0)
      (setup :user.plugins use)))
  )

