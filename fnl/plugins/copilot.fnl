{1 :github/copilot.vim
 :event :InsertEnter
 :cmd :Copilot
 :init (fn []
         (vim.keymap.set :i :<m-n> "<Plug>(copilot-next)")
         (vim.keymap.set :i :<m-p> "<Plug>(copilot-previous)")
         (vim.keymap.set :i "<c-;>" "<Plug>(copilot-suggest)"))}

