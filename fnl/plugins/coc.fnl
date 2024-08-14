(fn key-set [mode lhs rhs ?opts]
  (let [options (or ?opts {})]
    (vim.keymap.set mode lhs rhs options)))

(fn show-docs []
  (local cw (vim.fn.expand :<cword>))
  (if (< 0 (vim.fn.index [:vim :help] vim.bo.filetype))
      (vim.api.nvim_command (.. "h " cw))
      (vim.api.nvim_eval "coc#rpc#ready()")
      (vim.fn.CocActionAsync :doHover)
      (vim.api.nvim_command (.. "!" vim.o.keywordprg " " cw))))

{1 :neoclide/coc.nvim
 :branch :master
 :build "npm ci"
 :config (fn []
           (key-set :i :<c-space> "coc#refresh()" {:expr true})
           (key-set :n "]d" "<Plug>(coc-diagnostic-next)"
                    {:desc "Ir para próximo problema"})
           (key-set :n "[d" "<Plug>(coc-diagnostic-prev)"
                    {:desc "Ir para problema anterior"})
           (key-set :n "]e" "<Plug>(coc-diagnostic-next-error)"
                    {:desc "Ir para próximo erro"})
           (key-set :n "[e" "<Plug>(coc-diagnostic-prev-error)"
                    {:desc "Ir para erro anterior"})
           (key-set :n "<c-]>" "<Plug>(coc-definition)")
           (key-set :n :gi "<Plug>(coc-implementation)"
                    {:desc "Ir para implementação"})
           (key-set :n :gY "<Plug>(coc-type-definition)"
                    {:desc "Ir para definição de tipo"}) ; (key-set :n :gr "<Plug>(coc-references)" {:desc "Ver referências"})
           (key-set :n :K #(show-docs))
           (key-set :n :<leader>ci
                    "<cmd>CocCommand document.toggleInlayHint<CR>"
                    {:desc "Ativar/desativar dicas de código (inlay hints)"})
           (key-set :n :<leader>cr "<Plug>(coc-rename)" {:desc :Renomear})
           (key-set :n :<leader>cF "call CocAction('format)"
                    {:desc "Formatar código"})
           (key-set :n :<leader>. "<Plug>(coc-fix-current)" {:desc :Corrigir})
           (key-set :n :<leader>ca "<Plug>(coc-codeaction-cursor)"
                    {:desc "Ações de código"}) ; (key-set :n :<leader>cd "<cmd>CocList diagnostics<CR>" ;          {:desc "Listar problemas"}) ; (key-set :n :<leader>co "<cmd>CocList outline<CR>" ;          {:desc "Listar símbolos"}) ; (key-set :n :<leader>cp "<cmd>CocList -I symbols<CR>" ;          {:desc "Listar símbolos do projeto"})
           (key-set :n :<leader>cl "<Plug>(coc-codelens-action)"
                    {:desc "Ações de code lens"}))}

