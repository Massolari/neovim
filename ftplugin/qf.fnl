(import-macros {: map! : setlocal!} :hibiscus.vim)

(setlocal! :nobuflisted)
(map! [:n :buffer] :<CR> :<CR>)
(map! [:n :buffer] :q ":q<CR>")
