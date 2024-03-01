(when (= nil vim.g.colors_name)
  (vim.cmd.colorscheme :onedark))

(when (vim.startswith vim.g.colors_name :github)
  (vim.api.nvim_set_hl 0 :NormalFloat {:link :Normal}))

(let [signs {:Error " " :Warn " " :Info " " :Hint " "}]
  (each [type icon (pairs signs)]
    (let [hl (.. :DiagnosticSign type)]
      (vim.fn.sign_define hl {:text icon :texthl hl :numhl hl}))))

; Janela flutuante com a mesma cor de fundo do editor
(vim.api.nvim_set_hl 0 :NormalFloat {:link :Normal})
(vim.api.nvim_set_hl 0 :FloatBorder {:link :Normal})
