(local {: prefixed-keys} (require :functions))

{1 :tpope/vim-fugitive
 :cmd [:G :Git]
 :keys (prefixed-keys [{1 :ba 2 "<cmd>Git blame<CR>" :desc "Todos (all)"}
                       {1 :c 2 "<cmd>Git commit<CR>" :desc :Commit}
                       {1 :d 2 :<cmd>Gdiff<CR> :desc :Diff}
                       {1 :g 2 "<cmd>G log<CR>" :desc :Log}
                       {1 :l 2 "<cmd>Git pull --rebase<CR> " :desc :Pull}
                       {1 :p
                        2 "<cmd>Git -c push.default=current push<CR>"
                        :desc :Push}
                       {1 :P
                        2 "<cmd>Git -c push.default=current push --force<CR>"
                        :desc "Push (force)"}
                       {1 :s 2 :<cmd>Git<CR> :desc :Status}
                       {1 :w
                        2 :<cmd>Gwrite<CR>
                        :desc "Salvar e adicionar ao stage"}]
                      :<leader>g)}
