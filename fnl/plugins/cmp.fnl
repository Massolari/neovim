(local {: require-and} (require :functions))

(local M {1 :hrsh7th/nvim-cmp
          :event [:InsertEnter :CmdlineEnter]
          :dependencies [:hrsh7th/cmp-nvim-lsp
                         :PaterJason/cmp-conjure
                         :hrsh7th/cmp-buffer
                         :hrsh7th/cmp-path
                         :garymjr/nvim-snippets
                         :onsails/lspkind.nvim
                         :hrsh7th/cmp-calc
                         :hrsh7th/cmp-emoji
                         :hrsh7th/cmp-cmdline]})

(fn M.config []
  (local cmp (require :cmp))
  (local lspkind (require :lspkind)) ; Verificar as sources desabilitadas pelo usuário
  (local sources (let [disabled-sources (or vim.g.disabled_cmp_sources [])
                       default-sources [{:name :nvim_lsp}
                                        {:name :conjure}
                                        {:name :snippets}
                                        {:name :path}
                                        {:name :buffer
                                         :option {:get_bufnrs #(vim.api.nvim_list_bufs)}}
                                        {:name :calc}
                                        {:name :emoji}]]
                   (vim.tbl_filter #(not (vim.tbl_contains disabled-sources
                                                           $.name))
                                   default-sources)))
  (cmp.setup {:snippet {:expand (fn [args]
                                  (vim.snippet.expand args.body))}
              :view {:entries {:follow_cursor true}}
              :mapping {:<C-b> (cmp.mapping.scroll_docs -4)
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
                                                                       (.. (or (. lspkind.presets.codicons
                                                                                  vim_item.kind)
                                                                               "")
                                                                           " "
                                                                           vim_item.kind))
                                                                  (require-and :tailwindcss-colorizer-cmp
                                                                               #($.formatter entry
                                                                                             vim_item)))})}
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

