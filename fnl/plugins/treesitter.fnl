(local functions (require :functions))

(local M {1 :nvim-treesitter/nvim-treesitter
          :event :BufReadPost
          :dependencies [:nvim-treesitter/nvim-treesitter-textobjects]
          :build ":TSUpdate"})

(fn M.config []
  (local configs (require :nvim-treesitter.configs))
  (configs.setup {:highlight {:enable true}
                  :ensure_installed :all
                  :autotag {:enable true}
                  :context_commentstring {:enable true}
                  :incremental_selection {:enable true}
                  :indent {:enable true}
                  :textobjects {:select {:enable true
                                         :lookahead true
                                         :keymaps {:af "@function.outer"
                                                   :if "@function.inner"
                                                   :ac "@class.outer"
                                                   :ic "@class.inner"}}
                                :move {:enable true
                                       :set_jumps true
                                       :goto_next_start {"]f" {:query "@function.outer"
                                                               :desc "Next function start"}
                                                         "]a" {:query "@parameter.inner"
                                                               :desc "Next argument start"}}
                                       :goto_next_end {"]F" {:query "@function.outer"
                                                             :desc "Next function end"}
                                                       "]A" {:query "@parameter.inner"
                                                             :desc "Next argument end"}}
                                       :goto_previous_start {"[f" {:query "@function.outer"
                                                                   :desc "Previous function start"}
                                                             "[a" {:query "@parameter.inner"
                                                                   :desc "Previous argument start"}}
                                       :goto_previous_end {"[F" {:query "@function.outer"
                                                                 :desc "Previous function end"}
                                                           "[A" {:query "@parameter.inner"
                                                                 :desc "Previous argument end"}}}}})
  (functions.require-and :vim.treesitter.query
                         #(let [query (: (io.open (.. (vim.fn.stdpath :config)
                                                      :/fnl/data/queries/gleam.scm))
                                         :read :*a)]
                            ($.set :gleam :locals query))))

M
