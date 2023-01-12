(import-macros {: map!} :hibiscus.vim)

;; (local functions (require :functions))

(set vim.opt_local.cursorline false)
(set vim.opt_local.swapfile false)
(set vim.opt_local.number false)
(set vim.opt_local.relativenumber false)
(set vim.opt_local.signcolumn :no)
(set vim.opt_local.cursorcolumn false)
(set vim.opt_local.spell false)
(set vim.opt_local.list false)
(set vim.opt_local.bufhidden :wipe)
(set vim.opt_local.colorcolumn "")
(set vim.opt_local.foldcolumn :0)
(set vim.opt_local.matchpairs "")
;; (functions.clear-endspace)

(map! [:n :buffer] :q ":q<CR>")
