-- Leader
vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

-- Desabilitar editorconfig para fugitive
vim.g.EditorConfig_exclude_patterns = { 'fugitive://.*' }

-- Gruvbox
vim.g.gruvbox_italic = 1

-- Material
vim.g.material_style = 'lighter'

-- Neon
vim.g.neon_style = 'light'
vim.g.neon_bold = true

-- Tokyonight
vim.g.tokyonight_style = 'day'

-- Github
vim.g.function_style = 'italic'

-- Neovide
vim.g.neovide_floating_blur = 0
vim.g.neovide_window_floating_opacity = 1
vim.g.neovide_cursor_vfx_mode = 'ripple'

-- Indent blankline
vim.g.indent_blankline_filetype_exclude = { 'dashboard', 'lsp-installer', '' }

-- Lightspeed
vim.g.lightspeed_no_default_keymaps = true
