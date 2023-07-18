(local {: require-and : prefixed-keys} (require :functions))

{1 :NeogitOrg/neogit
 :dependencies :nvim-lua/plenary.nvim
 :config true
 :opts {:disable_commit_confirmation true}
 :keys (prefixed-keys [{1 :s 2 #(require-and :neogit #($.open)) :desc :Status}
                       {1 :c
                        2 #(require-and :neogit #($.open [:commit]))
                        :desc :Commit}
                       {1 :p
                        2 #(require-and :neogit #($.open [:push]))
                        :desc :Push}
                       {1 :l
                        2 #(require-and :neogit #($.open [:pull]))
                        :desc :Pull}] :<leader>g)}
