(require-macros :hibiscus.vim)

(when (= nil vim.g.colors_name)
  (color! github_light))

(exec [[:hi "link NormalFloat Normal"]])
