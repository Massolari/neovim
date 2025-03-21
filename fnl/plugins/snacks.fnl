(local functions (require :functions))
(local quotes (require :data.quotes))

(fn add-border [lines]
  (let [non-empty-lines (vim.tbl_filter #(> (string.len $) 0) lines)
        bigger-length (-> (vim.tbl_map string.len non-empty-lines)
                          (unpack)
                          (math.max))
        lines-bordered (vim.tbl_map #(let [pad (- bigger-length (string.len $))
                                           format-pattern (.. "%s%s%" pad "s%s")]
                                       (string.format format-pattern "│" $ ""
                                                      "│"))
                                    non-empty-lines)
        horizontal-border (string.rep "─" bigger-length)
        top-border (.. "╭" horizontal-border "╮")
        bottom-border (.. "╰" horizontal-border "╯")]
    (table.insert lines-bordered 1 top-border)
    (table.insert lines-bordered bottom-border)
    lines-bordered))

{1 :folke/snacks.nvim
 :priority 1000
 :lazy false
 :opts {:bigfile {:enabled true}
        :dashboard {:enabled true
                    :row 10
                    :preset {:header (let [header-number (functions.get-random 40)]
                                       (-> (.. "cat " (vim.fn.stdpath :config)
                                               :/fnl/data/ascii/ header-number
                                               :.cat)
                                           (vim.fn.systemlist)
                                           (add-border)
                                           (vim.fn.join "\n")))
                             :keys [{:icon "  "
                                     :desc "Buscar arquivo"
                                     :key :f
                                     :action ":FzfLua files"}
                                    {:icon "  "
                                     :desc "Arquivos recentes"
                                     :key :r
                                     :action ":FzfLua oldfiles"}
                                    {:icon "󰮗  "
                                     :desc "Procurar nos arquivos"
                                     :key :g
                                     :action ":FzfLua live_grep"}
                                    {:icon "  "
                                     :desc "Octo (Github)"
                                     :key :o
                                     :action ":Octo actions"}
                                    {:icon "󰦨  "
                                     :desc "Feed do dev.to"
                                     :key :d
                                     :action ":Devto feed"}
                                    {:icon "  "
                                     :desc "Novo arquivo"
                                     :key :n
                                     :action ":ene!"}
                                    {:icon " "
                                     :key :q
                                     :desc :Quit
                                     :action ":qa"}]}
                    :sections [{:section :header}
                               {:section :keys :gap 1 :padding 1}
                               {:text (do
                                        (math.randomseed (os.time))
                                        (functions.get-random-item quotes))
                                :align :center
                                :padding [0 2]}]}
        :explorer {:enabled true}
        :git {:enabled true}
        :indent {:enabled true}
        :input {:enabled true}
        :image {:enabled true}
        :lazygit {:enabled true :configure true}
        :notifier {:enabled true :top_down false}
        :picker {:enabled true}
        :quickfile {:enabled true}
        :rename {:enabled true}
        :scope {:enabled true}
        :terminal {:enabled true}
        :scroll {:enabled false}
        :statuscolumn {:enabled true}
        :words {:enabled true}}
 :keys [{1 :<leader>gy 2 #(_G.Snacks.lazygit) :desc "Abrir lazygit"}
        {1 :<leader>d 2 #(_G.Snacks.bufdelete) :desc "Deletar buffer"}
        {1 "]w"
         2 #(_G.Snacks.words.jump 1 true)
         :desc "Próxima palavra destacada"}
        {1 "[w"
         2 #(_G.Snacks.words.jump -1 true)
         :desc "Palavra destacada anterior"}
        {1 :<leader>t 2 #(_G.Snacks.terminal.toggle) :desc "Abrir terminal"}
        {1 :<leader>T
         2 #(_G.Snacks.terminal.toggle nil {:win {:style :float}})
         :desc "Abrir terminal fluante"}]}
