(local {: require-and} (require :functions))

(λ builtin [callback]
  (require-and :telescope.builtin callback))

(local M {1 :nvim-telescope/telescope.nvim
          :cmd :Telescope
          :keys [{1 :<leader>b
                  2 #(require-and :telescope.builtin
                                  #($.buffers (require-and :telescope.themes
                                                           #($.get_dropdown {:only_cwd true}))))
                  :desc :Buffers}
                 {1 :<leader>B
                  2 #(require-and :telescope.builtin
                                  #($.buffers (require-and :telescope.themes
                                                           #($.get_dropdown {}))))
                  :desc "Buffers (sem filtro)"}
                 ; {1 :<leader>ca 2 #(vim.lsp.buf.code_action) :desc "Ações"}
                 {1 :<leader>cd
                  2 "<cmd>Telescope coc workspace_diagnostics<cr>"
                  :desc "Problemas no projeto"}
                 {1 :<leader>co
                  2 "<cmd>Telescope coc document_symbols<cr>"
                  :desc "Buscar símbolos no arquivo"}
                 {1 :<leader>cp
                  2 "<cmd>Telescope coc workspace_symbols<cr>"
                  :desc "Buscar símbolos no projeto"}
                 {1 :<leader>cO
                  2 #(builtin #($.treesitter))
                  :desc "Buscar símbolos no arquivo com treesitter"}
                 {1 :<leader>cp
                  2 "<cmd>Telescope coc workspace_symbols<cr>"
                  :desc "Buscar símbolos no projeto"}
                 {1 :<leader>ee
                  2 #(builtin #($.builtin))
                  :desc "Comandos do Telescope"}
                 {1 :<leader>er
                  2 #(builtin #($.oldfiles))
                  :desc "Arquivos recentes"}
                 {1 :<leader>f
                  2 #(builtin #($.find_files))
                  :desc "Buscar (find) arquivo"}
                 {1 :<leader>gi
                  2 #(builtin #($.git_bcommits))
                  :desc "Histórico de commits do arquivo atual"}
                 {1 :<leader>gr
                  2 #(builtin #($.git_branches))
                  :desc "Listar branches"}
                 {1 :<leader>of
                  2 #(builtin #($.find_files {:cwd vim.g.obsidian_dir}))
                  :desc "Abrir arquivo"}
                 {1 :<leader>pe
                  2 #(builtin #($.grep_string))
                  :desc "Procurar texto sob cursor"}
                 {1 :<leader>pf
                  2 #(builtin #($.find_files))
                  :desc "Buscar (find) arquivo"}
                 {1 :<leader>ps
                  2 #(builtin #($.grep_string {:search (vim.fn.input "Procurar por: ")}))
                  :desc "Procurar (search) nos arquivos"}
                 {1 :gr
                  2 "<cmd>Telescope coc references<cr>"
                  :desc "Referências do símbolo sob cursor"}]
          :dependencies [:nvim-lua/plenary.nvim
                         {1 :nvim-telescope/telescope-fzf-native.nvim
                          :build :make}
                         :nvim-telescope/telescope-ui-select.nvim
                         :nvim-telescope/telescope-symbols.nvim
                         :fannheyward/telescope-coc.nvim]})

(fn M.config []
  (local telescope (require :telescope))
  (local actions (require :telescope.actions))
  (local layout-actions (require :telescope.actions.layout))
  (local themes (require :telescope.themes))
  (telescope.setup {:defaults {:mappings {:i {:<c-j> actions.move_selection_next
                                              :<c-k> actions.move_selection_previous
                                              :<esc> actions.close
                                              :<c-w> layout-actions.toggle_preview}}
                               :path_display [:filename_first]}
                    :pickers {:buffers {:mappings {:i {:<c-s-d> actions.delete_buffer}}}}
                    :extensions {:ui-select (themes.get_cursor)}})
  (telescope.load_extension :fzf)
  (telescope.load_extension :notify)
  (telescope.load_extension :coc)
  (telescope.load_extension :ui-select))

M

