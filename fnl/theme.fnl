(local {: diagnostic-icon} (require :constants))

(let [signs {:Error diagnostic-icon.error
             :Warn diagnostic-icon.warning
             :Info diagnostic-icon.info
             :Hint diagnostic-icon.int}]
  (each [type icon (pairs signs)]
    (let [hl (.. :DiagnosticSign type)]
      (vim.fn.sign_define hl {:text icon :texthl hl :numhl hl}))))

; Janela flutuante com a mesma cor de fundo do editor
(vim.api.nvim_set_hl 0 :NormalFloat {:link :Normal})
(vim.api.nvim_set_hl 0 :FloatBorder {:link :Normal})

