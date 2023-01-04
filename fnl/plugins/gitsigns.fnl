(import-macros {: map!} :hibiscus.vim)
(local {: has-files-dirs?} (require :functions))

{1 :lewis6991/gitsigns.nvim
 :dependencies [:nvim-lua/plenary.nvim]
 :event :BufReadPre
 :cond #(has-files-dirs? [:.git])
 :config {:numhl false
          :linehl false
          :on_attach (fn [_bufnr]
                       (let [gs (require :gitsigns)]
                         (map! [:n :expr :buffer] "]c"
                               #(if vim.wo.diff "]c"
                                    (do
                                      (vim.schedule #(gs.next_hunk))
                                      :<Ignore>)))
                         (map! [:n :expr :buffer] "[c"
                               #(if vim.wo.diff "[c"
                                    (do
                                      (vim.schedule #(gs.prev_hunk))
                                      :<Ignore>)))
                         (map! [:n :buffer] :<leader>ghu `gs.reset_hunk)
                         (map! [:v :buffer] :<leader>ghu
                               #(gs.reset_hunk [(vim.fn.line ".")
                                                (vim.fn.line :v)]))
                         (map! [:n :buffer] :<leader>ghv `gs.preview_hunk)
                         (map! [:n :buffer] :<leader>gbb
                               #(gs.blame_line {:full true}))))
          :current_line_blame true
          :current_line_blame_opts {:delay 0}}}
