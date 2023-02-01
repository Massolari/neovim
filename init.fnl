(local {: requireAnd : file-exists?} (require :functions))
;; Setup package manager

(let [lazypath (.. (vim.fn.stdpath :data) :/lazy/lazy.nvim)]
  (when (not (vim.loop.fs_stat lazypath))
    (vim.fn.system [:git
                    :clone
                    "--filter=blob:none"
                    :--single-branch
                    "https://github.com/folke/lazy.nvim.git"
                    lazypath]))
  (vim.opt.runtimepath:prepend lazypath))

(require :globals)

(requireAnd :lazy
            #($.setup :plugins
                      {:checker {:enabled true}
                       :performance {:rtp {:reset false}}}))

(require :options)
(require :commands)
(require :autocommands)
(require :mappings)

;; Arquivo de configuração do usuário

(let [user-file (.. (vim.fn.stdpath :config) :/lua/user/init.lua)]
  (when (file-exists? user-file)
    (require :user)))

(require :theme)
