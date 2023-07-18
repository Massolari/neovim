(local {: require-and} (require :functions))

{1 :norcalli/nvim-colorizer.lua
 :event :BufReadPre
 :name :colorizer
 :opts {1 "*"}
 :config (fn [opts]
           require-and
           :colorizer
           #($.setup opts {:RGB true
                           :RRGGBB true
                           :names true
                           :RRGGBBAA true
                           :rgb_fn true
                           :hsl_fn true
                           :css true
                           :css_fn true}))}
