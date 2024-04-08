(local {: require-and} (require :functions))

[{1 :JoosepAlviste/nvim-ts-context-commentstring
  :opts {:enable_autocmd false}
  :init #(set vim.g.skip_ts_context_commentstring_module true)
  :config true}
 {1 :echasnovski/mini.comment
  :event :VeryLazy
  :opts {:options {:custom_commentstring #(or (require-and :ts_context_commentstring.internal
                                                           #($.calculate_commentstring)
                                                           vim.bo.commentstring))}}}]
