(import-macros {: g!} :hibiscus.vim)

{1 :mg979/vim-visual-multi
 :branch :master
 :lazy false
 ; :keys [:<c-g> :<c-t>]
 :init (fn []
         (g! :VM_maps {"Find Under" :<C-t>
                       "Find Subword Under" :<C-t>
                       "Add Cursor Down" :<C-g>
                       "Add Cursor Up" :<M-g>
                       "Find Next" ")"
                       "Find Prev" "("
                       "Remove Region" "<M-,>"}))}
