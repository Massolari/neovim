(local {: on_attach} (require :plugins.nvim-lspconfig))

(local M {1 :nvimtools/none-ls.nvim
          :event :BufReadPost
          :dependencies :nvim-lua/plenary.nvim})

(fn M.config []
  (local null (require :null-ls))
  (local helpers (require :null-ls.helpers))
  (local gleam-format-source
         (helpers.make_builtin {:name :gleam-format
                                :filetypes [:gleam]
                                :method null.methods.FORMATTING
                                :generator_opts {:command :gleam
                                                 :args [:format :--stdin]
                                                 :to_stdin true}
                                :factory helpers.formatter_factory}))
  (null.setup {:sources [null.builtins.formatting.nimpretty
                         null.builtins.formatting.fnlfmt
                         null.builtins.formatting.stylua
                         null.builtins.formatting.prettier
                         null.builtins.diagnostics.eslint
                         null.builtins.code_actions.gitsigns
                         gleam-format-source]
               :debug true
               : on_attach}))

M
