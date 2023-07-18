(local {: requireAnd} (require :functions))

{1 :NeogitOrg/neogit
 :dependencies :nvim-lua/plenary.nvim
 :config true
 :opts {:disable_commit_confirmation true}
 :keys [{1 :<leader>gs 2 #(requireAnd :neogit #($.open)) :desc :Status}]}
