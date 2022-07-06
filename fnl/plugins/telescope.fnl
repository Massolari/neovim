(let [telescope (require :telescope)
      actions (require :telescope.actions)]
  (telescope.setup {:defaults {:mappings {:i {:<c-j> actions.move_selection_next
                                              :<c-k> actions.move_selection_previous
                                              :<esc> actions.close}}}})
  (telescope.load_extension :fzf))

;; (telescope.load_extension :coc))
