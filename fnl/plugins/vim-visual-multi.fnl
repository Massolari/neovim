{1 :mg979/vim-visual-multi
 :branch :master
 :keys [{1 :<c-g> :mode [:x :n]} :<c-t> :<M-g> {1 :g/ :mode :x}]
 :init (fn []
         (set vim.g.VM_maps
              {"Find Under" :<C-t>
               "Find Subword Under" :<C-t>
               "Add Cursor Down" :<C-g>
               "Add Cursor Up" :<M-g>
               "Find Next" ")"
               "Find Prev" "("
               "Visual Regex" :g/
               "Visual Cursors" :<c-g>
               "Remove Region" "<M-,>"}))}
