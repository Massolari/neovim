(local functions (require :functions))

{1 :NeogitOrg/neogit
 :dependencies :nvim-lua/plenary.nvim
 :config true
 :opts {:disable_commit_confirmation true}
 :keys (functions.prefixed-keys [{1 :s
                                  2 #(functions.require-and :neogit #($.open))
                                  :desc :Status}
                                 {1 :c
                                  2 #(functions.require-and :neogit
                                                            #($.open [:commit]))
                                  :desc :Commit}
                                 {1 :p
                                  2 #(functions.require-and :neogit
                                                            #($.open [:pull]))
                                  :desc :Pull}
                                 {1 :P
                                  2 #(functions.require-and :neogit
                                                            #($.open [:push]))
                                  :desc :Push}]
                                :<leader>g)}
