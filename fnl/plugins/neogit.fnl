(local {: require-and} (require :functions))

{1 :NeogitOrg/neogit
 :dependencies :nvim-lua/plenary.nvim
 :config true
 :opts {:disable_commit_confirmation true}
 :keys [{1 :<leader>gs 2 #(require-and :neogit #($.open)) :desc :Status}]}
