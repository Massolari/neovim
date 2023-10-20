(λ add [section]
  (vim.opt.winbar:append section))

(set vim.opt.winbar "")
(when (not vim.g.started_by_firenvim)
  (add "%#lualine_c_6_normal#")
  (add "▊")
  (add "%#lualine_c_7_normal#")
  (add " %t")
  (add "%#lualine_c_progress_normal#")
  (add " %{%v:lua.require'functions'.get_breadcrumbs()%}")
  (add "%=")
  (add "%#lualine_c_6_normal#")
  (add "▊"))
