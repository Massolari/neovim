(local {: require-and} (require :functions))

{1 :ibhagwan/fzf-lua
 :dependencies [:nvim-tree/nvim-web-devicons]
 :opts {:winopts {:backdrop 100} :files {:formatter [:path.filename_first 2]}}
 :keys [{1 :<leader>b
         2 #(require-and :fzf-lua
                         #($.buffers {:winopts {:width 0.4
                                                :height 0.6
                                                :preview {:layout :vertical}}}))
         :desc :Buffers}
        {1 :<leader>cp
         2 #(require-and :fzf-lua #($.lsp_workspace_symbols))
         :desc "Buscar símbolos no projeto"}
        {1 :<leader>ee
         2 #(require-and :fzf-lua #($.builtin))
         :desc "Comandos do Fzf-lua"}
        {1 :<leader>ehf
         2 #(require-and :fzf-lua
                         #($.files {:cwd (.. (vim.fn.stdpath :data) :/rest)}))
         :desc :Abrir}
        {1 :<leader>el
         2 #(require-and :fzf-lua
                         #($.blines {:winopts {:split "belowright new"}}))
         :desc "Pesquisar nas linhas do buffer"}
        {1 :<leader>enf
         2 #(require-and :fzf-lua
                         #($.files {:cwd vim.g.obsidian_dir :hidden false}))
         :desc "Abrir arquivo"}
        {1 :<leader>er
         2 #(require-and :fzf-lua #($.oldfiles))
         :desc "Arquivos recentes"}
        {1 :<leader>f
         2 #(require-and :fzf-lua #($.files))
         :desc "Buscar (find) arquivo"}
        {1 :<leader>gi
         2 #(require-and :fzf-lua #($.git_bcommits))
         :desc "Histórico de commits do arquivo atual"}
        {1 :<leader>gr
         2 #(require-and :fzf-lua #($.git_branches))
         :desc "Listar branches"}
        {1 :gO
         2 #(require-and :fzf-lua #($.lsp_document_symbols))
         :desc "Buscar símbolos no arquivo"}
        {1 :<leader>o
         2 #(require-and :fzf-lua #($.treesitter))
         :desc "Buscar símbolos no arquivo com treesitter"}
        {1 :<leader>pe
         2 #(require-and :fzf-lua #($.grep_cword))
         :desc "Procurar texto sob cursor"}
        {1 :<leader>pz 2 #(require-and :fzf-lua #($.zoxide)) :desc :Zoxide}
        {1 :<leader>ps
         2 #(require-and :fzf-lua #($.live_grep))
         :desc "Procurar (search) nos arquivos"}
        {1 :gri
         2 #(require-and :fzf-lua #($.lsp_implementations))
         :desc "Implementações"}
        {1 :grr
         2 #(require-and :fzf-lua #($.lsp_references))
         :desc "Referências"}
        {1 :gY
         2 #(require-and :fzf-lua #($.lsp_typedefs))
         :desc "Definição do tipo"}]}
