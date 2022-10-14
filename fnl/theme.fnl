(require-macros :hibiscus.vim)
(local functions (require :functions))

(when (= nil vim.g.colors_name)
  ;; (color! github_dark))
  ;; (color! gruvbox))
  (color! onehalflight))

(if (vim.startswith vim.g.colors_name :one)
    (vim.cmd "hi! link VertSplit Normal"))

;; (vim.cmd "hi VertSplit guifg=#000 guibg=Normal"))

; Cor para espaços em branco no final do arquivo
(exec [[:hi (.. "EndSpace guibg=" (functions.get-color :Error :fg :Red))]])

;; Janela flutuante com a mesma cor de fundo do editor
(vim.cmd "hi! link NormalFloat Normal")
(vim.cmd "hi! link FloatBorder Normal")

(let [signs {:Error " " :Warn " " :Info " " :Hint " "}]
  (each [type icon (pairs signs)]
    (let [hl (.. :DiagnosticSign type)]
      (vim.fn.sign_define hl {:text icon :texthl hl :numhl hl}))))
