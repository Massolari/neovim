(local toggleterm (require :toggleterm))

(toggleterm.setup {:shade_terminals false
                   :direction :horizontal
                   :insert_mappings false
                   :on_open (fn [term]
                              (vim.keymap.set :t :jk "<c-\\><c-n>"
                                              {:buffer term.bufnr})
                              (vim.keymap.set :t :kj "<c-\\><c-n>"
                                              {:buffer term.bufnr}))
                   :terminal_mappings false})
