(local {: require-and} (require :functions))
(local js-formatter [[:prettierd :prettier]])

{1 :stevearc/conform.nvim
 :config (fn []
           (require-and :conform
                        #($.setup {:formatters_by_ft {:lua [:stylua]
                                                      :elm [:elm_format]
                                                      :fennel [:fnlfmt]
                                                      :gleam [:gleam]
                                                      :go [:gofmt]
                                                      :jsx js-formatter
                                                      :javascript js-formatter
                                                      :typescript js-formatter
                                                      :typescriptreact js-formatter
                                                      :tsx js-formatter}
                                   :log_level vim.log.levels.INFO
                                   :format_on_save {:timeout_ms 10000
                                                    :lsp_fallback true}}))
           (set vim.o.formatexpr "v:lua.require'conform'.formatexpr()"))}

