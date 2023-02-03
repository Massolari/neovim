(local M {1 :nvim-telescope/telescope.nvim
          :branch :0.1.x
          :cmd :Telescope
          :keys [{1 :<leader>ca 2 #(vim.lsp.buf.code_action) :desc "Ações"}]
          :dependencies [:nvim-lua/plenary.nvim
                         {1 :nvim-telescope/telescope-fzf-native.nvim
                          :build :make}
                         :nvim-telescope/telescope-ui-select.nvim
                         :nvim-telescope/telescope-symbols.nvim]})

(fn M.config []
  (local telescope (require :telescope))
  (local actions (require :telescope.actions))
  (local themes (require :telescope.themes))
  (telescope.setup {:defaults {:mappings {:i {:<c-j> actions.move_selection_next
                                              :<c-k> actions.move_selection_previous
                                              :<esc> actions.close
                                              "<c-\\>" :which_key}}}
                    :pickers {:buffers {:mappings {:i {:<c-s-d> actions.delete_buffer}}}}
                    :extensions {:ui-select (themes.get_cursor)}})
  (telescope.load_extension :fzf)
  (telescope.load_extension :ui-select))

M
