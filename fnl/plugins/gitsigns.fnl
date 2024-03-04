(local {: has-files-dirs?} (require :functions))

{1 :lewis6991/gitsigns.nvim
 :dependencies [:nvim-lua/plenary.nvim]
 :event :BufReadPre
 :cond #(has-files-dirs? [:.git])
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
                                       {:buffer true :expr true})
                       (vim.keymap.set :n "[c"
                                       #(if vim.wo.diff
                                            "[c"
                                            (do
                                              (vim.schedule #(gs.prev_hunk))
                                              :<Ignore>))
                                       {:buffer true :expr true})
                       (vim.keymap.set :n :<leader>ghu #(gs.reset_hunk)
                                       {:buffer true})
                       (vim.keymap.set :v :<leader>ghu
                                       #(gs.reset_hunk [(vim.fn.line ".")
                                                        (vim.fn.line :v)])
                                       {:buffer true})
                       (vim.keymap.set :n :<leader>ghv
                                       #(gs.preview_hunk) {:buffer true})
                       (vim.keymap.set :n :<leader>gbb
                                       #(gs.blame_line {:full true}))) {:buffer true})
        :current_line_blame true
        :current_line_blame_opts {:delay 0}}}
