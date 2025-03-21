(local functions (require :constants))

{1 :akinsho/bufferline.nvim
 :event :VeryLazy
 :opts {:options {:diagnostics :nvim_lsp
                  :diagnostics_indicator (fn [_count level]
                                           (if (= level :error)
                                               functions.diagnostic-icon.error
                                               functions.diagnostic-icon.warning))}}}
