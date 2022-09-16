(require-macros :hibiscus.vim)

;; Leader
(g! mapleader " ")
(g! maplocalleader "\\")

;; Desabilitar editorconfig para fugitive
(g! EditorConfig_exclude_patterns ["fugitive://.*"])

;; Gruvbox
(g! gruvbox_italic 1)
(g! gruvbox_sign_column :bg0)

;; Catppuccin
(g! catppuccin_flavour :latte)

;; Neovide
(g! neovide_floating_blur 0)
(g! neovide_window_floating_opacity 1)
(g! neovide_cursor_vfx_mode :ripple)

;; Indent blankline
(g! indent_blankline_filetype_exclude [:dashboard :lsp-installer ""])

;; Copilot
(g! copilot_no_tab_map true)

;; Vim-multi
(g! VM_maps {"Find Under" :<C-t>
             "Find Subword Under" ""
             "Add Cursor Down" :<C-g>
             "Add Cursor Up" ""})

;; Conjure
(g! conjure#mapping#doc_word "K")


;; Emmet
(g! user_emmet_mode :iv)
(g! user_emmet_leader_key :<C-g>)
