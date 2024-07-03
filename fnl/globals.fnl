;; Leader

(set vim.g.mapleader " ")
(set vim.g.maplocalleader "\\")

;; Neovide

(set vim.g.neovide_floating_blur 0)
(set vim.g.neovide_window_floating_opacity 1)
(set vim.g.neovide_cursor_vfx_mode :ripple)

;; Obsidian

(set vim.g.obsidian_dir
     (.. vim.env.HOME "/Library/Mobile Documents/iCloud~md~obsidian/Documents"))

;; Node

(set vim.g.node_path (.. (os.getenv :HOME) :/.nix-profile/bin/node))

;; Desabilitar netrw

(set vim.g.loaded_netrw 1)
(set vim.g.loaded_netrwPlugin 1)

