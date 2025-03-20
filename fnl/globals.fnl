;; Leader

(set vim.g.mapleader " ")
(set vim.g.maplocalleader "\\")

;; Neovide

(set vim.g.neovide_cursor_vfx_mode :ripple)

;; Obsidian

(set vim.g.obsidian_dir
     (.. vim.env.HOME "/Library/Mobile Documents/iCloud~md~obsidian/Documents"))

;; Local plugins

(set vim.g.local_plugins_dir (.. vim.env.HOME :/lua-projects))

;; Desabilitar netrw

(set vim.g.loaded_netrw 1)
(set vim.g.loaded_netrwPlugin 1)
