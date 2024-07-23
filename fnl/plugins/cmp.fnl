(local {: require-and} (require :functions))

(local M {1 :hrsh7th/nvim-cmp
          :event [:InsertEnter :CmdlineEnter]
          :dependencies [:hrsh7th/cmp-buffer
                         :hrsh7th/cmp-path
                         :hrsh7th/cmp-cmdline]})

(fn M.config []
  (local cmp (require :cmp)) ; (cmp.setup {:view {:entries {:follow_cursor true}} ;             :mapping {:<C-b> (cmp.mapping.scroll_docs -4) ;                       :<C-f> (cmp.mapping.scroll_docs 4) ;                       :<C-space> (cmp.mapping.complete) ;                       :<C-e> (cmp.mapping {:i (cmp.mapping.abort) ;                                            :c (cmp.mapping.close)}) ;                       :<C-p> (fn [fallback] ;                                (if (cmp.visible) ;                                    (cmp.select_prev_item {:behavior cmp.SelectBehavior.Insert})
  ;                                    (fallback))) ;                       :<C-n> (fn [fallback] ;                                (if (cmp.visible) ;                                    (cmp.select_next_item {:behavior cmp.SelectBehavior.Insert})
  ;                                    (fallback))) ;                       :<C-y> (cmp.mapping.confirm {:select true})} ;             :window {:completion (cmp.config.window.bordered) ;                      :documentation (cmp.config.window.bordered)} ;             : sources})
  ;; Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
  (cmp.setup.cmdline "/" {:mapping (cmp.mapping.preset.cmdline)
                          :sources [{:name :buffer}]})
  ;; Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  (cmp.setup.cmdline ":"
                     {:mapping (cmp.mapping.preset.cmdline)
                      :sources (cmp.config.sources [{:name :path}]
                                                   [{:name :cmdline}])}))

M

