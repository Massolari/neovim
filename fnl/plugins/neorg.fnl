{1 :nvim-neorg/neorg
 :build ":Neorg sync-parsers"
 :keys [{1 :<leader>en
         2 "<cmd>Neorg workspace notes<CR>"
         :desc "Abrir notas do Neorg"}]
 :opts {:load {:core.defaults {}
               ;; Loads default behaviour
               :core.concealer {}
               ;; Adds pretty icons to your documents
               :core.dirman {;; Manages Neorg workspaces
                             :config {:workspaces {:notes "~/notes"}}}}}
 :dependencies [:nvim-lua/plenary.nvim]}
