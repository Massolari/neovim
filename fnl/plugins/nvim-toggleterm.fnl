(import-macros {: fstring : empty?} :hibiscus.core)
(local {: requireAnd : with-input} (require :functions))

(λ open-terminal [cmd id ?custom-opts]
  (let [Terminal (requireAnd :toggleterm.terminal #(. $ :Terminal))
        default-opts {: cmd : id :hidden true :direction :float}
        opts (vim.tbl_extend :keep (or ?custom-opts {}) default-opts)
        term (Terminal:new opts)]
    (term:toggle)))

{1 :akinsho/nvim-toggleterm.lua
 :cmd :ToggleTerm
 :name :toggleterm
 :opts {:shade_terminals false
          :direction :horizontal
          :insert_mappings false
          :on_open (fn [term]
                     (vim.keymap.set :t :jk "<c-\\><c-n>" {:buffer term.bufnr})
                     (vim.keymap.set :t :kj "<c-\\><c-n>" {:buffer term.bufnr}))
          :terminal_mappings false}
 :init (fn []
         (vim.keymap.set :n :<leader>gy
                         #(open-terminal :lazygit 1000
                                         {:on_open (fn []
                                                     nil)})
                         {:desc "Abrir lazygit"})
         (vim.keymap.set :n :<leader>eh
                         #(with-input "Cheat.sh query: "
                                      (fn [query]
                                        (when (not (empty? query))
                                          (let [formatted-query (query:gsub " "
                                                                            "+")
                                                cmd (fstring "curl cht.sh/${formatted-query}")]
                                            (open-terminal cmd 1001
                                                           {:close_on_exit false
                                                            :start_in_insert false})))))
                         {:desc "Procurar em cheat.sh"}))}
