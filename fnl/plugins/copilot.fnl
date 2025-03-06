{1 :github/copilot.vim
 :event :InsertEnter
 :cmd :Copilot
 :init (fn []
         (set vim.g.copilot_filetypes {:gitcommit true})
         (vim.keymap.set :i :<m-n> "<Plug>(copilot-next)")
         (vim.keymap.set :i :<m-p> "<Plug>(copilot-previous)")
         (vim.keymap.set :i "<c-;>" "<Plug>(copilot-suggest)"))}
