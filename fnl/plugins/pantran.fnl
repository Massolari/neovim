(local {: require-and} (require :functions))

(λ exec [callback]
  (require-and :pantran callback))

{1 :potamides/pantran.nvim
 :keys [{1 :<leader>ep
         2 #(exec #($.motion_translate))
         :desc "Traduzir com Pantran"
         :expr true}
        {1 :<leader>ep
         2 #(exec #($.motion_translate))
         :desc "Traduzir com Pantran"
         :expr true
         :mode :x}]
 :opts {:default_engine :google}
 :config true}
