(local {: diagnostic-icon} (require :constants))

{1 :akinsho/bufferline.nvim
 :event :VeryLazy
 :opts {:options {:diagnostics :nvim_lsp
                  :diagnostics_indicator (fn [_count level]
                                           (if (= level :error)
                                               diagnostic-icon.error
                                               diagnostic-icon.warning))}}}
