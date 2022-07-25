(require-macros :hibiscus.vim)

(when (= nil vim.g.colors_name)
  (color! onehalflight))

;; (color! github_light))
;; (color! gruvbox))

(if (vim.startswith vim.g.colors_name :one)
    (vim.cmd "hi! link VertSplit Normal"))

;; (vim.cmd "hi VertSplit guifg=#000 guibg=Normal"))

(exec [[:hi "link NormalFloat Normal"]])

(let [signs {:Error " " :Warn " " :Info " " :Hint " "}]
  (each [type icon (pairs signs)]
    (let [hl (.. :DiagnosticSign type)]
      (vim.fn.sign_define hl {:text icon :texthl hl :numhl hl}))))
