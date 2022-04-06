(require-macros :hibiscus.vim)

(require :plugins)
(require :settings)
(require :commands)
(require :autocommands)
(require :mappings)

; Arquivo de configuração do usuário
(let [user-file (.. (vim.fn.stdpath "config") "/lua/user/init.lua")]
  (when (> (vim.fn.filereadable user-file) 0)
    (require :user)))

(require :setup)
(require :theme)
