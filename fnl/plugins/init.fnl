(local {: dir-exists?} (require :functions))
(vim.cmd "packadd cfilter")

(local plugins [{1 :Massolari/web.nvim
                 :cond (dir-exists? (.. vim.env.HOME :/nvim-web-browser))
                 :dir (.. vim.env.HOME :/nvim-web-browser)
                 :dependencies :nvim-lua/plenary.nvim}])

(let [(_ user-plugins) (xpcall #(require :user.plugins)
                               (fn []
                                 []))]
  (each [_ user-plugin (pairs user-plugins)]
    (table.insert plugins user-plugin)))

plugins
