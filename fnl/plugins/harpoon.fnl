(local functions (require :functions))

{1 :ThePrimeagen/harpoon
 :config true
 :keys [{1 :<leader><space>
         2 #(functions.require-and :harpoon.mark
                                   (fn [harpoon]
                                     (harpoon.add_file)
                                     (functions.show-info "Arquivo marcado"
                                                          :Harpoon)))
         :desc "Marcar arquivo com harpoon"}
        {1 :<leader>ph
         2 #(functions.require-and :harpoon.ui #($.toggle_quick_menu))
         :desc "Mostrar marcas do harpoon"}
        (->> [1 2 3 4 5 6 7 8 9 0]
             (vim.tbl_map (fn [n]
                            {1 (.. :<leader> n)
                             2 #(functions.require-and :harpoon.ui
                                                       #($.nav_file n))
                             :desc (.. "Ir para marca " n " do harpoon")}))
             (unpack))]}
