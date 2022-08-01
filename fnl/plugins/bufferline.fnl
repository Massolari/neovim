(local bufferline (require :bufferline))

(bufferline.setup {:options {:diagnostics :coc
                             :diagnostics_indicator (fn [_
                                                         _
                                                         diagnostics_dict
                                                         _]
                                                      (let [diagnostics {:error ""
                                                                         :warning ""
                                                                         :hint ""
                                                                         :info ""}
                                                            get-icon #(match $1
                                                                        :error "  "
                                                                        :warning "  "
                                                                        :hint "  "
                                                                        :info "  ")]
                                                        (each [e n (pairs diagnostics_dict)]
                                                          (tset diagnostics e
                                                                (.. (get-icon e)
                                                                    n)))
                                                        (.. diagnostics.error
                                                            diagnostics.warning
                                                            diagnostics.hint
                                                            diagnostics.info)))
                             :custom_areas {:right (fn []
                                                     (let [clients (vim.lsp.buf_get_clients)
                                                           buf-filetype (vim.api.nvim_buf_get_option 0
                                                                                                     :filetype)
                                                           result []]
                                                       (each [_ client (pairs clients)]
                                                         (let [client-filetypes (or client.config.filetypes
                                                                                    [])]
                                                           (when (->> buf-filetype
                                                                      (vim.fn.index client-filetypes)
                                                                      (not= -1))
                                                             (table.insert result
                                                                           {:text (.. " " client.name " ")}))))
                                                       result))}}})
