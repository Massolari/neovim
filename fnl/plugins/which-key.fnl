(local which-key (require :which-key))

(which-key.setup {:plugins {:spelling {:enabled true}
                            :presets {:operators false}}})
