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
                                                            diagnostics.info)))}})
