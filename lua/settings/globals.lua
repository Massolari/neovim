-- Leader
vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

-- Desabilitar editorconfig para fugitive
vim.g.EditorConfig_exclude_patterns = { 'fugitive://.*' }

-- Gruvbox
vim.g.gruvbox_italic = 1
vim.g.gruvbox_sign_column = 'bg0'

-- Neovide
vim.g.neovide_floating_blur = 0
vim.g.neovide_window_floating_opacity = 1
vim.g.neovide_cursor_vfx_mode = 'ripple'

-- Indent blankline
vim.g.indent_blankline_filetype_exclude = { 'dashboard', 'lsp-installer', '' }

-- Glow
vim.g.glow_style = vim.opt.background:get()
