(local {: on_attach} (require :plugins.nvim-lspconfig))

(local M {1 :nvimtools/none-ls.nvim
          :event :BufReadPost
          :dependencies :nvim-lua/plenary.nvim})

(fn M.config []
  (local null (require :null-ls))
  (null.setup {:sources [null.builtins.formatting.nimpretty
                         null.builtins.formatting.fnlfmt
                         null.builtins.formatting.stylua
                         null.builtins.formatting.prettier]
               :debug true
               : on_attach}))

M
