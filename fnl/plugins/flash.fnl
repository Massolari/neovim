(local functions (require :functions))

{1 :folke/flash.nvim
 :event :VeryLazy
 :opts {:modes {:char {:enabled false}}}
 :keys [{1 :s
         2 #(functions.require-and :flash #($.jump))
         :mode [:n :o :x]
         :desc :Flash}
        {1 :S
         2 #(functions.require-and :flash #($.treesitter))
         :mode [:n :o]
         :desc "Flash Treesitter"}
        {1 :r
         2 #(functions.require-and :flash #($.remote))
         :mode :o
         :desc "Remote Flash"}]}
