(import-macros {: map! : setlocal!} :hibiscus.vim)

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
          (let [winid (vim.fn.win_getid)]
            (vim.api.nvim_win_set_cursor winid [line 0])))))

(map! [:n :buffer] :D
      (fn []
        (let [line (vim.fn.line ".")
              line-text (vim.fn.getline ".")
              file-name (vim.fn.substitute line-text "|\\d\\+|.*" "" "")
              pattern (.. "/\\V" (vim.fn.escape file-name "/\\") "/")
              winid (vim.fn.win_getid)]
          (vim.cmd (.. "Cfilter! " pattern))
          (pcall vim.api.nvim_win_set_cursor winid [line 0]))))
