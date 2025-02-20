(local {: require-and} (require :functions))

{1 :ibhagwan/fzf-lua
 ;; optional for icon support
 :dependencies [:nvim-tree/nvim-web-devicons]
 :opts {:winopts {:backdrop 100} :files {:formatter [:path.filename_first 2]}}
 :keys [{1 :<leader>b
         2 #(require-and :fzf-lua
                         #($.buffers {:winopts {:width 0.4
                                                :height 0.6
                                                :preview {:layout :vertical}}}))
         :desc :Buffers}
        {1 :<leader>el
         2 #(require-and :fzf-lua
                         #($.lines {:winopts {:split "belowright new"}}))
         :desc "Pesquisar nas linhas do buffer"}
        {1 :<leader>o
         2 #(require-and :fzf-lua #($.lsp_document_symbols))
         :desc "Buscar símbolos no arquivo"}
        {1 :<leader>O
         2 #(require-and :fzf-lua #($.treesitter))
         :desc "Buscar símbolos no arquivo com treesitter"}
        {1 :<leader>cp
         2 #(require-and :fzf-lua #($.lsp_workspace_symbols))
         :desc "Buscar símbolos no projeto"}
        {1 :<leader>ee
         2 #(require-and :fzf-lua #($.builtin))
         :desc "Comandos do Fzf-lua"}
        {1 :<leader>er
         2 #(require-and :fzf-lua #($.oldfiles))
         :desc "Arquivos recentes"}
        {1 :<leader>gi
         2 #(require-and :fzf-lua #($.git_bcommits))
         :desc "Histórico de commits do arquivo atual"}
        {1 :<leader>gr
         2 #(require-and :fzf-lua #($.git_branches))
         :desc "Listar branches"}
        {1 :<leader>pe
         2 #(require-and :fzf-lua #($.grep_word))
         :desc "Procurar texto sob cursor"}
        {1 :<leader>f
         2 #(require-and :fzf-lua #($.files))
         :desc "Buscar (find) arquivo"}
        {1 :<leader>ps
         2 #(require-and :fzf-lua #($.live_grep))
         :desc "Procurar (search) nos arquivos"}]}

