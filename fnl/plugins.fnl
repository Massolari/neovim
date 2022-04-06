(require-macros :hibiscus.vim)

(exec [
  [:packadd "packer.nvim"]
  [:packadd "matchit"]
])

(local packer (require :packer))

(fn setup [package config]
  "Faz o require e chama o setup com o valor de config"
  (#(let [p (require package)] (p.setup config))))

(packer.startup (fn [use]
  ; Packer can manage itself
  (use :wbthomason/packer.nvim)

  ; Suporte à fennel
  (use :udayvir-singh/tangerine.nvim)
  (use :udayvir-singh/hibiscus.nvim)


  ; Ícones
  (use :kyazdani42/nvim-web-devicons)

  ; Editorconfig
  (use :editorconfig/editorconfig-vim)

  ; Sessões
  (use :xolox/vim-misc)
  (use {1 :xolox/vim-session
        :requires :xolox/vim-misc})

  ; Buscador
  (use {1 :nvim-telescope/telescope.nvim
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
            (telescope.load_extension "coc")))})

  (use {1 :nvim-telescope/telescope-fzf-native.nvim :run "make"})
  (use :fannheyward/telescope-coc.nvim)

  ; Sintasse para várias linguagens
  (use {1 :nvim-treesitter/nvim-treesitter
        :run ":TSUpdate"})

  ; Comentário de forma fácil
  (use {1 :numToStr/Comment.nvim
        :config
          (setup :Comment {})})

  ; Habilita o uso do emmet (<C-g>,)
  (use {1 :mattn/emmet-vim
        :config (fn []
          ; Usar o emmet apenas no modo visual ou no modo inserção
          (g! user_emmet_mode "iv")
          (g! user_emmet_leader_key "<C-g>"))})

  ; Habilita a busca rapida usando duas letras
  (use {1 :rlane/pounce.nvim
        :config (setup :pounce {})})

  ; Temas
  (use :ellisonleao/gruvbox.nvim)
  (use :projekt0n/github-nvim-theme)


  ; Mostra um git diff na coluna de número e comandos para hunks
  (use {1 :lewis6991/gitsigns.nvim
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
           :current_line_blame_opts {:delay 0}})})

  ; Mostra linhas de indentação
  (use {1 :lukas-reineke/indent-blankline.nvim
        :config (setup :indent_blankline {:show_current_context true})})

  ; Auto-fechamento de delimitadores
  (use {1 :windwp/nvim-autopairs
        :config (setup :nvim-autopairs {})})

  ; Operação com delimitadores
  (use :tpope/vim-surround)

  ; Se mover melhor com o f/t
  (use :unblevable/quick-scope)

  ; Text-objects melhorados e com seek
  (use :wellle/targets.vim)

  ; Explorador de arquivos
  (use {1 :kyazdani42/nvim-tree.lua
        :requires :kyazdani42/nvim-web-devicons
        :config (setup :nvim-tree {:disable_netrw false})})

  ; Warper para comandos do git
  (use {1 :tpope/vim-fugitive
        :opt true
        :cmd ["G" "Git" "Gdiff" "Gclog" "Gwrite"]})
  (use {1 :pwntester/octo.nvim
        :requires
        [:nvim-lua/plenary.nvim
         :nvim-telescope/telescope.nvim
         :kyazdani42/nvim-web-devicons]
        :config (setup :octo {})})

  ; Biblioteca de snippets
  (use :rafamadriz/friendly-snippets)

  ; Status line
  (use {1 :nvim-lualine/lualine.nvim
        :requires { 1 :kyazdani42/nvim-web-devicons :opt true }
        :config #(require :statusline)})

  ; Guia de atalhos
  (use {1 :folke/which-key.nvim
        :config (setup :which-key
         {:plugins
          {:spelling
           {:enabled true}}})})

  ; Cliente REST
  (use {1 :diepm/vim-rest-console
        :opt true
        :ft "rest"})

  ; LSP do Nvim
  (use {1 :neoclide/coc.nvim :branch "release"})

  ; Alternador de terminal
  (use {1 :akinsho/nvim-toggleterm.lua
        :config (setup :toggleterm
          {:open_mapping "<leader>t"
           :shade_terminals false
           :direction "horizontal"
           :insert_mappings false
           :terminal_mappings false})})

  ; Buffers no topo
  (use {1 :akinsho/bufferline.nvim
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
                (.. diagnostics.error diagnostics.warning diagnostics.hint diagnostics.info)))}})})

  ; Copiloto
  (use :github/copilot.vim)

  ; Correção do CursorHold
  (use :antoinemadec/FixCursorHold.nvim)

  ; Colorir hexademical de cores
  (use {1 :norcalli/nvim-colorizer.lua
        :config (setup :colorizer
          {1 :*
           :css {:hsl_fn true}
           :scss {:hsl_fn true}})})

  ; Dashboard
  (use :ChristianChiarulli/dashboard-nvim)

  ; Wildmenu melhorado
  (use :gelguy/wilder.nvim)

  ; Integração com Dash (MacOS)
  (use {1 :mrjones2014/dash.nvim
        :run "make install"})

  ; Pré-visualizar markdown
  (use :ellisonleao/glow.nvim)

  (let [user-file (.. (vim.fn.stdpath "config") "/lua/user/plugins.lua")]
    (when (> (vim.fn.filereadable user-file) 0)
      (setup :user.plugins use)))
  ))

