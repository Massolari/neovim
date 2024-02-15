{1 :echasnovski/mini.files
 :version false
 :event :VeryLazy
 :keys [{1 :<leader>eF
         2 "<cmd>lua MiniFiles.open(vim.api.nvim_buf_get_name(0))<CR>"
         :desc "Explorador de arquivos (a partir do arquivo atual)"}
        {1 :<leader>ef
         2 "<cmd>lua MiniFiles.open()<CR>"
         :desc "Explorador de arquivos"}]
 :opts {:windows {:preview true}
        :mappings {:go_in :L :go_in_plus "" :go_out :H :go_out_plus ""}}
 :config true}
