(local {: require-and : with-input} (require :functions))

(λ open-terminal [cmd id ?custom-opts]
  (let [Terminal (require-and :toggleterm.terminal #(. $ :Terminal))
        default-opts {: cmd : id :hidden true :direction :float}
        opts (vim.tbl_extend :keep (or ?custom-opts {}) default-opts)
        term (Terminal:new opts)]
    (if (not= opts.size nil)
        (term:toggle opts.size)
        (term:toggle))))

{1 :akinsho/nvim-toggleterm.lua
 :cmd :ToggleTerm
 :name :toggleterm
 :opts {:shade_terminals false
        :direction :horizontal
        :insert_mappings false
        :on_open (fn [term]
                   (vim.keymap.set :t :<Esc> "<c-\\><c-n>" {:buffer term.bufnr}))
        :terminal_mappings false}
 :keys [{1 :<leader>gy
         2 #(open-terminal :lazygit 1000
                           {:on_open (fn []
                                       nil)})
         :desc "Abrir lazygit"}
        {1 :<leader>t
         2 "<cmd>exe v:count1 . \"ToggleTerm direction=horizontal\"<CR>"
         :desc :Terminal}
        {1 :<leader>T
         2 "<cmd>exe v:count1 . \"ToggleTerm direction=float\"<CR>"
         :desc "Terminal flutuante"}]
 :init (fn []
         (let [open-w3m #(open-terminal (.. "w3m " $1) 1002
                                        {:on_open #(set vim.opt.buflisted true)
                                         :direction :vertical
                                         :size (* vim.o.columns 0.5)})]
           (vim.keymap.set :n :<leader>ebb #(open-w3m :-v) {:desc "Início"})
           (vim.keymap.set :n :<leader>ebs
                           (fn []
                             (with-input "Search on the web: "
                               (fn [input]
                                 (when (not= input "")
                                   (open-w3m (.. "\"https://www.google.com/search?q="
                                                 (string.gsub input " " "+")
                                                 "\""))))))
                           {:desc "Pesquisar no Google"})))}
