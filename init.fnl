(require-macros :hibiscus.vim)

(require :plugins)
(require :globals)
(require :options)
(require :commands)
(require :autocommands)
(require :mappings)

; Arquivo de configuração do usuário
(local {: file-exists?} (require :functions))
(let [user-file (.. (vim.fn.stdpath :config) :/lua/user/init.lua)]
  (when (file-exists? user-file)
    (require :user)))

(require :statusline)
(require :winbar)
(require :theme)
