(import-macros {: g!} :hibiscus.vim)

{1 :mattn/emmet-vim
 :keys [{1 "<C-g>," :mode :i}]
 :init (fn []
         (g! :user_emmet_mode :iv)
         (g! :user_emmet_leader_key :<C-g>))}
