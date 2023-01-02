(local {: requireAnd} (require :functions))

{1 :akinsho/nvim-toggleterm.lua
 :cmd :ToggleTerm
 :name :toggleterm
 :config {:shade_terminals false
          :direction :horizontal
          :insert_mappings false
          :on_open (fn [term]
                     (vim.keymap.set :t :jk "<c-\\><c-n>" {:buffer term.bufnr})
                     (vim.keymap.set :t :kj "<c-\\><c-n>" {:buffer term.bufnr}))
          :terminal_mappings false}
 :init (fn []
         (vim.keymap.set :n :<leader>gy
                         (fn []
                           (let [Terminal (requireAnd :toggleterm.terminal
                                                      #(. $ :Terminal))
                                 lazygit (Terminal:new {:cmd :lazygit
                                                        :hidden true
                                                        :direction :float
                                                        :on_open (fn []
                                                                   nil)
                                                        :id 1000})]
                             (lazygit:toggle)))
                         {:desc "Abrir lazygit"}))}
