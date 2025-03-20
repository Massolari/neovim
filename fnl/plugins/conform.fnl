(local {: require-and} (require :functions))
(local js-formatter [:biome :prettierd :prettier])

{1 :stevearc/conform.nvim
 :event :BufRead
 :opts {:formatters_by_ft {:lua [:stylua]
                           :elm [:elm_format]
                           :fennel [:fnlfmt]
                           :gleam [:gleam]
                           :go [:gofmt]
                           :jsx js-formatter
                           :javascript js-formatter
                           :typescript js-formatter
                           :typescriptreact js-formatter
                           :tsx js-formatter}
        :default_format_opts {:stop_after_first true}
        :log_level vim.log.levels.INFO
        :format_on_save {:timeout_ms 10000 :lsp_fallback true}}
 :config (fn [_ opts]
           (require-and :conform #($.setup opts))
           (set vim.o.formatexpr "v:lua.require'conform'.formatexpr()"))}
