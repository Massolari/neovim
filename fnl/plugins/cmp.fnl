(local M {1 :hrsh7th/nvim-cmp
          :event [:InsertEnter :CmdlineEnter]
          :dependencies [:hrsh7th/cmp-nvim-lsp
                         :PaterJason/cmp-conjure
                         :hrsh7th/cmp-buffer
                         :hrsh7th/cmp-path
                         :L3MON4D3/LuaSnip
                         :rafamadriz/friendly-snippets
                         :saadparwaiz1/cmp_luasnip
                         :onsails/lspkind.nvim
                         :hrsh7th/cmp-calc
                         :hrsh7th/cmp-emoji
                         :hrsh7th/cmp-cmdline]})

(fn M.config []
  (local cmp (require :cmp))
  (local lspkind (require :lspkind))
  (local luasnip (require :luasnip))
  (let [loader (require :luasnip.loaders.from_vscode)]
    (loader.lazy_load)) ; Verificar as sources desabilitadas pelo usuário
  (local sources (let [disabled-sources (or vim.g.disabled_cmp_sources [])
                       enabled-sources {}]
                   (each [_ source (ipairs [{:name :nvim_lsp}
                                            {:name :conjure}
                                            {:name :cmp_tabnine}
                                            {:name :luasnip}
                                            {:name :path}
                                            ;; {:name :buffer}
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
                        :<C-y> (cmp.mapping.confirm {:select true})
                        :<C-q> (cmp.mapping (fn []
                                              (vim.api.nvim_feedkeys (vim.fn.copilot#Accept (vim.api.nvim_replace_termcodes :<c-q>
                                                                                                                            true
                                                                                                                            true
                                                                                                                            true))
                                                                     :n true)))}
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
  ;; Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
  (cmp.setup.cmdline "/" {:mapping (cmp.mapping.preset.cmdline)
                          :sources [{:name :buffer}]})
  ;; Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  (cmp.setup.cmdline ":"
                     {:mapping (cmp.mapping.preset.cmdline)
                      :sources (cmp.config.sources [{:name :path}]
                                                   [{:name :cmdline}])}))

M
