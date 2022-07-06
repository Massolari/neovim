(local cmp (require :cmp))
(local lspkind (require :lspkind))
(local luasnip (require :luasnip))
(let [loader (require :luasnip.loaders.from_vscode)]
  (loader.lazy_load))

; Verificar as sources desabilitadas pelo usuário
(local sources (let [disabled-sources (or vim.g.disabled_cmp_sources [])
                     enabled-sources {}]
                 (each [_ source (ipairs [{:name :nvim_lsp}
                                          {:name :cmp_tabnine}
                                          {:name :luasnip}
                                          {:name :path}
                                          {:name :buffer}
                                          {:name :calc}
                                          {:name :emoji}])]
                   (var disabled? false)
                   (each [_ disabled (ipairs disabled-sources)]
                     (if (= source.name disabled)
                         (set disabled? true)))
                   (if (not disabled?)
                       (table.insert enabled-sources source)))
                 enabled-sources))

(cmp.setup {:snippet {:expand (fn [args]
                                (luasnip.lsp_expand args.body))}
            :mapping {:<C-d> (cmp.mapping.scroll_docs -4)
                      :<C-f> (cmp.mapping.scroll_docs 4)
                      :<C-space> (cmp.mapping.complete)
                      :<C-e> (cmp.mapping {:i (cmp.mapping.abort)
                                           :c (cmp.mapping.close)})
                      :<C-p> (fn [fallback]
                               (if (cmp.visible)
                                   (cmp.select_prev_item {:behavior cmp.SelectBehavior.Insert})
                                   (fallback)))
                      :<C-n> (fn [fallback]
                               (if (cmp.visible)
                                   (cmp.select_next_item {:behavior cmp.SelectBehavior.Insert})
                                   (fallback)))
                      :<C-y> (cmp.mapping.confirm {:select true})}
            :window {:completion (cmp.config.window.bordered)
                     :documentation (cmp.config.window.bordered)}
            :formatting {:format (lspkind.cmp_format {:mode :symbol_text
                                                      :maxwidth 50
                                                      :before (fn [entry
                                                                   vim_item]
                                                                (set vim_item.kind
                                                                     (.. (. lspkind.presets.default
                                                                            vim_item.kind)
                                                                         " "
                                                                         vim_item.kind))
                                                                (set vim_item.menu
                                                                     (. {:path "[Path]"
                                                                         :buffer "[Buffer]"
                                                                         :calc "[Calc]"
                                                                         :nvim_lsp "[LSP]"
                                                                         :cmp_tabnine "[TabNine]"
                                                                         :luasnip "[LuaSnip]"
                                                                         :emoji "[Emoji]"}
                                                                        entry.source.name))
                                                                vim_item)})}
            : sources})
