(local constants (require :constants))

(let [signs {:Error constants.diagnostic-icon.error
             :Warn constants.diagnostic-icon.warning
             :Info constants.diagnostic-icon.info
             :Hint constants.diagnostic-icon.int}]
  (each [type icon (pairs signs)]
    (let [hl (.. :DiagnosticSign type)]
      (vim.fn.sign_define hl {:text icon :texthl hl :numhl hl}))))

; Janela flutuante com a mesma cor de fundo do editor
(vim.api.nvim_set_hl 0 :NormalFloat {:link :Normal})
