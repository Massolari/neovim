(import-macros {: g!} :hibiscus.vim)

;; Leader

(g! :mapleader " ")
(g! :maplocalleader "\\")

;; Neovide

(g! :neovide_floating_blur 0)
(g! :neovide_window_floating_opacity 1)
(g! :neovide_cursor_vfx_mode :ripple)

;; Obsidian

(g! :obsidian_dir
    (.. vim.env.HOME "/Library/Mobile Documents/iCloud~md~obsidian/Documents"))
