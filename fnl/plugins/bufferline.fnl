(local {: diagnostic-icon} (require :constants))

{1 :akinsho/bufferline.nvim
 :opts {:options {:diagnostics :coc
                  :diagnostics_indicator (fn [_count level]
                                           (if (= level :error)
                                               diagnostic-icon.error
                                               diagnostic-icon.warning))}}}

