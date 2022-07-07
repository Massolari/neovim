(local telescope (require :telescope))
(local actions (require :telescope.actions))
(local themes (require :telescope.themes))

(telescope.setup {:defaults {:mappings {:i {:<c-j> actions.move_selection_next
                                            :<c-k> actions.move_selection_previous
                                            :<esc> actions.close}}}
                  :extensions {:ui-select (themes.get_dropdown)}})

(telescope.load_extension :fzf)
(telescope.load_extension :ui-select)
