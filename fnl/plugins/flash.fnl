(local {: requireAnd} (require :functions))

{1 :folke/flash.nvim
 :event :VeryLazy
 :opts {}
 :keys [{1 :S
         2 #(requireAnd :flash #($.treesitter))
         :mode [:n :o :x]
         :desc "Flash Treesitter"}
        {1 :r 2 #(requireAnd :flash #($.remote)) :mode :o :desc "Remote Flash"}]}
