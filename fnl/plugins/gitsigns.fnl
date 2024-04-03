{1 :lewis6991/gitsigns.nvim
 :dependencies [:nvim-lua/plenary.nvim]
 :event :BufReadPre
 :opts {:numhl false
        :linehl false
        :on_attach (fn [_bufnr]
                     (let [gs (require :gitsigns)]
                       (vim.keymap.set :n "]c"
                                       #(if vim.wo.diff
                                            "]c"
                                            (do
                                              (vim.schedule #(gs.next_hunk))
                                              :<Ignore>))
                                       {:buffer true
                                        :expr true
                                        :desc "Próximo git hunk"})
                       (vim.keymap.set :n "[c"
                                       #(if vim.wo.diff
                                            "[c"
                                            (do
                                              (vim.schedule #(gs.prev_hunk))
                                              :<Ignore>))
                                       {:buffer true
                                        :expr true
                                        :desc "Git hunk anterior"})
                       (vim.keymap.set :n :<leader>ghu #(gs.reset_hunk)
                                       {:buffer true})
                       (vim.keymap.set :v :<leader>ghu
                                       #(gs.reset_hunk [(vim.fn.line ".")
                                                        (vim.fn.line :v)])
                                       {:buffer true :desc "Desfazer (undo)"})
                       (vim.keymap.set :n :<leader>ghv #(gs.preview_hunk)
                                       {:buffer true :desc :Ver})
                       (vim.keymap.set :n :<leader>gbb
                                       #(gs.blame_line {:full true
                                                        :desc :Linha})))
                     {:buffer true})
        :current_line_blame true
        :current_line_blame_opts {:delay 0}}}
