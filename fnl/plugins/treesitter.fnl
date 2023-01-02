(local M {1 :nvim-treesitter/nvim-treesitter :event :BufReadPost :build ":TSUpdate"})

(fn M.config []
  (local configs (require :nvim-treesitter.configs))
  (configs.setup {:highlight {:enable true}
                  :ensure_installed :all
                  :ignore_install [:phpdoc]
                  :incremental_selection {:enable true}
                  ;; :keymaps {:initial_selection :gnn
                  ;;           :node_incremental :grn
                  ;;           :node_decremental :grm
                  ;;           :scope_incremental :grc}}
                  :indent {:enable true}
                  :textobjects {:select {:enable true
                                         :lookahead true
                                         :keymaps {:af "@function.outer"
                                                   :if "@function.inner"
                                                   :ac "@class.outer"
                                                   :ic "@class.inner"}}
                                :move {:enable true
                                       :set_jumps true
                                       :goto_next_start {"]m" "@function.outer"
                                                         "]]" "@class.outer"}
                                       :goto_next_end {"]M" "@function.outer"
                                                       "][" "@class.outer"}
                                       :goto_previous_start {"[m" "@function.outer"
                                                             "[[" "@class.outer"}
                                       :goto_previous_end {"[M" "@function.outer"
                                                           "[]" "@class.outer"}}}}))

M
