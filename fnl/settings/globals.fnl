(require-macros :hibiscus.vim)

; Leader
(g! mapleader " ")
(g! maplocalleader "\\")

; Desabilitar editorconfig para fugitive
(g! EditorConfig_exclude_patterns ["fugitive://.*"])

; Gruvbox
(g! gruvbox_italic 1)
(g! gruvbox_sign_column :bg0)

; Neovide
(g! neovide_floating_blur 0)
(g! neovide_window_floating_opacity 1)
(g! neovide_cursor_vfx_mode :ripple)

; Indent blankline
(g! indent_blankline_filetype_exclude [:dashboard :lsp-installer ""])

; Glow
(g! glow_style (vim.opt.background:get))

; CoC
(g! coc_snippet_next :<c-j>)
(g! coc_global_extensions [:coc-marketplace
                           :coc-snippets
                           :coc-markdown-preview-enhanced
                           :coc-symbol-line])

; Copilot
(g! copilot_no_tab_map true)

; Vim-multi
(g! VM_maps {"Find Under" ""
             "Find Subword Under" ""
             "Add Cursor Down" :<C-g>
             "Add Cursor Up" :<C-t>})
