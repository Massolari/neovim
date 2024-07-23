(local {: require-and} (require :functions))

{1 :RRethy/vim-illuminate
 :event :BufReadPost
 :keys [{1 "]w"
         2 #(require-and :illuminate #($.goto_next_reference))
         :desc "Próxima palavra destacada"}
        {1 "[w"
         2 #(require-and :illuminate #($.goto_prev_reference))
         :desc "Palavra destacada anterior"}]}

