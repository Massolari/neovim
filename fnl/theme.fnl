(import-macros {: color! : exec} :hibiscus.vim)
(local functions (require :functions))

(when (= nil vim.g.colors_name)
  (color! :github_light))
;; (color! :intellij))
;; (color! :artesanal))

(if (vim.startswith vim.g.colors_name :one)
    (vim.cmd "hi! link VertSplit Normal"))

;; (vim.cmd "hi DiffChange guibg=Normal")
;; (vim.cmd "hi DiffDelete guibg=Normal")

; Cor para espaços em branco no final do arquivo

(exec [[:hi (.. "EndSpace guibg=" (functions.get-color :Error :fg :Red))]])
;; Janela flutuante com a mesma cor de fundo do editor

(vim.api.nvim_set_hl 0 :NormalFloat {:link :Normal})
(vim.api.nvim_set_hl 0 :FloatBorder {:link :Normal})

(let [signs {:Error " " :Warn " " :Info " " :Hint " "}]
  (each [type icon (pairs signs)]
    (let [hl (.. :DiagnosticSign type)]
      (vim.fn.sign_define hl {:text icon :texthl hl :numhl hl}))))
