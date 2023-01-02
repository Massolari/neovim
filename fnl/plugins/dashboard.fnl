(local M {1 :glepnir/dashboard-nvim :config #(require :plugins.dashboard)})

(fn M.config []
(local functions (require :functions))
(local quotes (require :data.quotes))
(local dashboard (require :dashboard))

(local config-folder (vim.fn.stdpath :config))

  (set dashboard.hide_winbar false)
  (set dashboard.session_directory (.. (vim.fn.stdpath :data) :/sessions))
  (let [header-number (functions.get-random 30)]
    (set dashboard.custom_header
         (vim.fn.systemlist (.. "cat " config-folder :/fnl/data/ascii/
                                header-number :.cat))))
  (set dashboard.custom_center
       [{:icon " "
         :desc "Buscar arquivo        "
         :action "Telescope find_files"}
        {:icon " "
         :desc "Abrir projeto         "
         :action "Telescope projects"}
        {:icon " "
         :desc "Procurar nos arquivos "
         :action "Telescope live_grep"}
        {:icon " " :desc "Octo (Github)         " :action "Octo actions"}
        {:icon " " :desc "Feed do dev.to        " :action "Forem feed"}
        {:icon " " :desc "Novo arquivo          " :action ":ene!"}])
  (math.randomseed (os.time))
  (set dashboard.custom_footer (functions.get-random-item quotes)))

M
