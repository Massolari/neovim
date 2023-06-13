(local {: on_attach} (require :plugins.nvim-lspconfig))

(local M {1 :jose-elias-alvarez/null-ls.nvim
          :event :BufReadPost
          :dependencies :nvim-lua/plenary.nvim})

(fn M.config []
  (local null (require :null-ls))
  (local code-support (require :code-support))
  (null.setup {:sources (vim.list_extend [null.builtins.formatting.nimpretty
                                          null.builtins.formatting.fnlfmt
                                          null.builtins.formatting.stylua
                                          null.builtins.formatting.prettier
                                          null.builtins.diagnostics.eslint
                                          null.builtins.code_actions.gitsigns]
                                         (code-support.null-ls-sources))
               :debug true
               : on_attach}))

M
