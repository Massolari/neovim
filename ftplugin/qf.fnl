(import-macros {: map! : setlocal!} :hibiscus.vim)

(λ restore-cursor-position [old-line]
  (let [winid (vim.fn.win_getid)]
    (pcall vim.api.nvim_win_set_cursor winid [old-line 0])))

(λ run-and-restore-cursor-position [f]
  (let [old-line (vim.fn.line ".")]
    (pcall f)
    (restore-cursor-position old-line)))

(setlocal! :nobuflisted)
(map! [:n :buffer] :<CR> :<CR>)
(map! [:n :buffer] :q ":q<CR>")
(map! [:n :buffer :nowait] :d
      (fn []
        (let [line (vim.fn.line ".")
              quickfix (vim.fn.getqflist)]
          (table.remove quickfix line)
          (vim.fn.setqflist quickfix)
          (vim.cmd :copen)
          (restore-cursor-position line))))

(map! [:n :buffer] :D
      (fn []
        (let [line (vim.fn.line ".")
              line-text (vim.fn.getline ".")
              file-name (vim.fn.substitute line-text "|\\d\\+|.*" "" "")
              pattern (.. "/\\V" (vim.fn.escape file-name "/\\") "/")]
          (vim.cmd (.. "Cfilter! " pattern))
          (restore-cursor-position line))))

(map! [:n :buffer] :u
      #(run-and-restore-cursor-position #(vim.cmd "silent colder")))
(map! [:n :buffer] :U
      #(run-and-restore-cursor-position #(vim.cmd "silent cnewer")))
(map! [:n :buffer] :<c-r>
      #(run-and-restore-cursor-position #(vim.cmd "silent cnewer")))
