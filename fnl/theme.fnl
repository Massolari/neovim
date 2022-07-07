(require-macros :hibiscus.vim)

(when (= nil vim.g.colors_name)
  (color! solarized-flat))

;; (color! github_light))
;; (color! gruvbox))

(exec [[:hi "link NormalFloat Normal"]])

(let [signs {:Error " " :Warn " " :Info " " :Hint " "}]
  (each [type icon (pairs signs)]
    (let [hl (.. :DiagnosticSign type)]
      (vim.fn.sign_define hl {:text icon :texthl hl :numhl hl}))))
