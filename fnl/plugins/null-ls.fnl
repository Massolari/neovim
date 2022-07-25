(local null (require :null-ls))

(null.setup {:sources [null.builtins.formatting.fnlfmt
                       null.builtins.code_actions.gitsigns]})
