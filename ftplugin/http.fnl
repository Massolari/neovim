(local kulala (require :kulala))

(vim.keymap.set :n :<localleader>r #(kulala.run)
                {:desc "Executar a requisição"})

(vim.keymap.set :n :<localleader>i #(kulala.inspect)
                {:desc "Inspeccionar a requisição"})

(vim.keymap.set :n "]" #(kulala.jump_next))
(vim.keymap.set :n "[" #(kulala.jump_prev))
