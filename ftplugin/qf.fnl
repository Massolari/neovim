(λ restore-cursor-position [old-line]
  (let [winid (vim.fn.win_getid)]
    (pcall vim.api.nvim_win_set_cursor winid [old-line 0])))

(λ run-and-restore-cursor-position [f]
  (let [old-line (vim.fn.line ".")]
    (pcall f)
    (restore-cursor-position old-line)))

(set vim.opt_local.buflisted false)
(vim.keymap.set :n :<CR> :<CR> {:buffer true})
(vim.keymap.set :n :q ":q<CR>" {:buffer true})

;; Remove o item atual da lista de quickfix
(vim.keymap.set :n :d
                (fn []
                  (let [line (vim.fn.line ".")
                        quickfix (vim.fn.getqflist)]
                    (table.remove quickfix line)
                    (vim.fn.setqflist quickfix)
                    (vim.cmd :copen)
                    (restore-cursor-position line)))
                {:buffer true :nowait true})

;; Remove todos os itens da lista de quickfix que correspondem ao mesmo arquivo do item atual
(vim.keymap.set :n :D
                (fn []
                  (let [line (vim.fn.line ".")
                        qf-list (vim.fn.getqflist)
                        current-item (. qf-list line)
                        current-bufnr (and current-item current-item.bufnr)
                        filtered-list (icollect [_ item (ipairs qf-list)]
                                        (when (not= item.bufnr current-bufnr)
                                          item))]
                    (vim.fn.setqflist filtered-list) ; (vim.cmd :copen)
                    (restore-cursor-position line)))
                {:buffer true})

(vim.keymap.set :n :u
                #(run-and-restore-cursor-position #(vim.cmd "silent colder"))
                {:buffer true})

(vim.keymap.set :n :U
                #(run-and-restore-cursor-position #(vim.cmd "silent cnewer"))
                {:buffer true})

(vim.keymap.set :n :<c-r>
                #(run-and-restore-cursor-position #(vim.cmd "silent cnewer"))
                {:buffer true})

(vim.keymap.set :n :<leader>f ":Cfilter " {:buffer true :desc "Filtrar items"})

