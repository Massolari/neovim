(vim.cmd "packadd cfilter")

(local plugins [;; Fennel
                {1 :udayvir-singh/tangerine.nvim :priority 1001 :lazy false}
                :udayvir-singh/hibiscus.nvim
                {1 :unblevable/quick-scope :event :VeryLazy}
                ;; Interface
                ; Destaque na palavra sob o cursor
                {1 :RRethy/vim-illuminate :event :BufReadPost}
                {1 :windwp/nvim-autopairs :event :InsertEnter :config true}
                ;; Outros
                ; Funcionalidades para a linguagem Nim
                {1 :alaviss/nim.nvim :ft :nim}
                {1 :roobert/tailwindcss-colorizer-cmp.nvim}
                {1 :Massolari/web.nvim
                 :dir (.. vim.env.HOME :/nvim-web-browser)
                 :dependencies :nvim-lua/plenary.nvim}])

(let [(_ user-plugins) (xpcall #(require :user.plugins)
                               (fn []
                                 []))]
  (each [_ user-plugin (pairs user-plugins)]
    (table.insert plugins user-plugin)))

plugins
