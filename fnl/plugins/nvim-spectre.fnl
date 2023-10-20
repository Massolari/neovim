(local {: require-and} (require :functions))

{1 :windwp/nvim-spectre
 :dependencies [:nvim-lua/plenary.nvim]
 :keys [{1 :<leader>es
         2 #(require-and :spectre #($.open))
         :desc "Procurar e substituir"}]
 :config true}
