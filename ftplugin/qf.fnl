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
(vim.keymap.set :n :d
                (fn []
                  (let [line (vim.fn.line ".")
                        quickfix (vim.fn.getqflist)]
                    (table.remove quickfix line)
                    (vim.fn.setqflist quickfix)
                    (vim.cmd :copen)
                    (restore-cursor-position line)))
                {:buffer true :nowait true})

(vim.keymap.set :n :D
                (fn []
                  (let [line (vim.fn.line ".")
                        line-text (vim.fn.getline ".")
                        file-name (vim.fn.substitute line-text "|\\d\\+|.*" ""
                                                     "")
                        pattern (.. "/\\V" (vim.fn.escape file-name "/\\") "/")]
                    (vim.cmd (.. "Cfilter! " pattern))
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
