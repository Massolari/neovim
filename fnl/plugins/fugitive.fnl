(local {: prefixed-keys} (require :functions))

{1 :tpope/vim-fugitive
 :cmd [:G :Git]
 :keys (prefixed-keys [{1 :ba 2 "<cmd>Git blame<CR>" :desc "Todos (all)"}
                       {1 :d 2 :<cmd>Gdiff<CR> :desc :Diff}
                       {1 :g 2 "<cmd>G log<CR>" :desc :Log}
                       {1 :w
                        2 :<cmd>Gwrite<CR>
                        :desc "Salvar e adicionar ao stage"}]
                      :<leader>g)}
