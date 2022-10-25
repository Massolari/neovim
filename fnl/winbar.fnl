(λ add [section]
   (vim.opt.winbar:append section))

(set vim.opt.winbar "")
(add "%#lualine_c_2_normal#")
(add "▊")
(add "%#lualine_c_3_normal#")
(add " %t")
(add "%#lualine_c_progress_normal#")
(add " %{%v:lua.require'nvim-navic'.get_location()%}")
(add "%=")
(add "%#lualine_c_2_normal#")
(add "▊")

