(require-macros :hibiscus.vim)
(local {: file-exists?} (require :functions))

(require :plugins)
(require :settings)
(require :commands)
(require :autocommands)
(require :mappings)

; Arquivo de configuração do usuário
(let [user-file (.. (vim.fn.stdpath :config) :/lua/user/init.lua)]
  (when (file-exists? user-file)
    (require :user)))

(require :statusline)
(require :setup)
(require :theme)
