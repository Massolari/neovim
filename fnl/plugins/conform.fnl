(local {: require-and} (require :functions))
(local js-formatter [[:prettierd :prettier]])

{1 :stevearc/conform.nvim
 :config (fn []
           (require-and :conform
                        #($.setup {:formatters_by_ft {:lua [:stylua]
                                                      :elm [:elm_format]
                                                      :fennel [:fnlfmt]
                                                      :gleam [:gleam]
                                                      :jsx js-formatter
                                                      :javascript js-formatter
                                                      :typescript js-formatter
                                                      :typescriptreact js-formatter
                                                      :tsx js-formatter
                                                      :v [:vfmt]}
                                   :log_level vim.log.levels.INFO
                                   :format_on_save {:timeout_ms 10000
                                                    :lsp_fallback true}
                                   :formatters {:vfmt {:command :v
                                                       :stdin false
                                                       :args [:fmt
                                                              :-w
                                                              :$FILENAME]}}}))
           (set vim.o.formatexpr "v:lua.require'conform'.formatexpr()"))
 :keys [{1 :<leader>cf
         2 #(require-and :conform #($.format))
         :desc "Formatar código"}]}

