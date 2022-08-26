(require-macros :hibiscus.vim)

(local functions (require :functions))
(local quotes (require :data.quotes))

(local config-folder (vim.fn.stdpath :config))

(g! dashboard_default_executive :telescope)

(let [header-number (functions.get-random 30)]
  (g! dashboard_custom_header
      (vim.fn.systemlist (.. "cat " config-folder :/fnl/data/ascii/ header-number :.cat))))

(let [user-file (.. config-folder :/lua/user/init.lua)]
  (g! dashboard_custom_section
      {:a {:description ["  Buscar arquivo        "]
           :command "Telescope find_files"}
       :c {:description ["  Abrir projeto         "]
           :command "Telescope projects"}
       :d {:description ["  Procurar nos arquivos "]
           :command "Telescope live_grep"}
       :e {:description ["  Octo (Github)         "]
           :command "Octo actions"}
       :f {:description ["  Feed do dev.to        "]
           :command "Forem feed"}
       :g {:description ["  Novo arquivo          "] :command ":ene!"}}))

(math.randomseed (os.time))
(g! dashboard_custom_footer (functions.get-random-item quotes))
