(import-macros {: fstring!} :hibiscus.core)
(local {: get-random : get-random-item : requireAnd} (require :functions))

(local M {1 :glepnir/dashboard-nvim :event :VimEnter})

(fn add-border [lines]
  (let [utf8 (require :utf8)
        bigger-length (-> (vim.tbl_map utf8.len lines) (unpack) (math.max))
        lines-bordered (vim.tbl_map #(let [pad (- bigger-length (utf8.len $))
                                           format-pattern (.. "%s%s%" pad "s%s")]
                                       (string.format format-pattern "│" $ ""
                                                      "│"))
                                    lines)
        horizontal-border (string.rep "─" bigger-length)
        top-border (.. "╭" horizontal-border "╮")
        bottom-border (.. "╰" horizontal-border "╯")]
    (table.insert lines-bordered 1 top-border)
    (table.insert lines-bordered bottom-border)
    lines-bordered))

(fn M.config []
  (local quotes (require :data.quotes))
  (local config-folder (vim.fn.stdpath :config))
  (requireAnd :dashboard
              #($.setup {:theme :doom
                         :config {:header (let [header-number (get-random 40)]
                                            (-> (fstring! "cat ${config-folder}/fnl/data/ascii/${header-number}.cat")
                                                (vim.fn.systemlist)
                                                (add-border)))
                                  :center [{:icon " "
                                            :desc "Buscar arquivo        "
                                            :action "Telescope find_files"}
                                           {:icon " "
                                            :desc "Abrir projeto         "
                                            :action "Telescope projects"}
                                           {:icon " "
                                            :desc "Procurar nos arquivos "
                                            :action "Telescope live_grep"}
                                           {:icon " "
                                            :desc "Octo (Github)         "
                                            :action "Octo actions"}
                                           {:icon " "
                                            :desc "Feed do dev.to        "
                                            :action "Forem feed"}
                                           {:icon " "
                                            :desc "Novo arquivo          "
                                            :action ":ene!"}]
                                  :footer (do
                                            (math.randomseed (os.time))
                                            (get-random-item quotes))}})))

M
