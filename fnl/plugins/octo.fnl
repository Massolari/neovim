(local functions (require :functions))

{1 :pwntester/octo.nvim
 :config true
 :cmd :Octo
 :opts {:picker :fzf-lua}
 :keys (functions.prefixed-keys [{1 :ic
                                  2 "<cmd>Octo issue create<CR>"
                                  :desc :Criar}
                                 {1 :il
                                  2 "<cmd>Octo issue list<CR>"
                                  :desc :Listar}
                                 {1 :o
                                  2 "<cmd>Octo actions<CR>"
                                  :desc "Octo (ações do GitHub)"}
                                 {1 :uc
                                  2 "<cmd>Octo pr create<CR>"
                                  :desc :Criar}
                                 {1 :ul
                                  2 "<cmd>Octo pr list<CR>"
                                  :desc :Listar}]
                                :<leader>g)}
