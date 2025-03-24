(local constants (require :constants))
(local functions (require :functions))

(local M {1 :nvim-lualine/lualine.nvim
          :cond (not vim.g.started_by_firenvim)
          :event :VimEnter
          :dependencies [{1 :nvim-tree/nvim-web-devicons
                          :opts {:override {:gleam {:icon " "
                                                    :color "#ffaff3"
                                                    :cterm_color :219
                                                    :name :Gleam}}}}]})

(fn hide-in-width? []
  (> (vim.fn.winwidth 0) 80))

(local colors {:yellow :DarkYellow
               :cyan "#008080"
               :darkblue "#081633"
               :green "#98be65"
               :orange "#FF8800"
               :violet "#a9a1e1"
               :magenta "#c678dd"
               :blue "#51afef"
               :red "#ec5f67"})

; Componentes reutilizáveis
(λ border [padding]
  {1 (fn [] "▊") :color {:fg colors.blue} : padding :separator ""})

(local filename {1 :filename :padding 0 :color {:fg colors.magenta :gui :bold}})
(local filename-path (vim.tbl_extend :force filename {:path 1}))

(fn M.config []
  (local config
         {:options {:disabled_filetypes {:statusline [:dashboard]
                                         :winbar [:dashboard :kulala_ui]}
                    :component_separators "·"
                    :globalstatus (= (vim.opt.laststatus:get) 3)
                    :section_separators ""}
          ; Os [] são para remover os componentes padrão
          :sections {:lualine_a []
                     :lualine_b []
                     :lualine_c [(border {:right 1})
                                 {1 :mode :separator "" :padding {:right 1}}
                                 {1 :filetype
                                  :icon_only true
                                  :padding 0
                                  :separator ""}
                                 filename-path
                                 {1 :location :padding {:left 1} :separator ""}
                                 {1 :progress
                                  :padding {:left 1 :right 1}
                                  :color {:gui :bold}
                                  :separator ""}
                                 {1 :diagnostics
                                  :symbols {:error constants.diagnostic-icon.error
                                            :warn constants.diagnostic-icon.warning
                                            :info constants.diagnostic-icon.info
                                            :hint constants.diagnostic-icon.hint}
                                  :separator ""}
                                 {1 #(vim.fn.reg_recording)
                                  :cond #(not= "" (vim.fn.reg_recording))
                                  :icon "󰑊"
                                  :separator ""
                                  :color {:fg colors.red :gui :bold}}
                                 {1 (fn [] "%=") :separator ""}
                                 {1 :lsp_status :ignore_lsp ["GitHub Copilot"]}]
                     :lualine_x [{1 #(functions.require-and :noice
                                                            #(-> ($.api.status.search.get)
                                                                 (string.gsub "W "
                                                                              "⤴ ")))
                                  :cond #(functions.require-and :noice
                                                                #($.api.status.search.has))
                                  :separator ""}
                                 {1 (fn []
                                      (let [clients (vim.lsp.get_clients {:name "GitHub Copilot"})
                                            has-copilot (> (length clients) 0)]
                                        (if has-copilot " " " ")))
                                  :separator ""}
                                 {1 :branch
                                  :icon " "
                                  :color {:fg colors.violet :gui :bold}
                                  :separator ""}
                                 {1 :diff
                                  :symbols {:added " "
                                            :modified " "
                                            :removed " "}
                                  :diff_color {:added {:fg colors.green
                                                       :gui :bold}
                                               :modified {:fg colors.orange
                                                          :gui :bold}
                                               :removed {:fg colors.red
                                                         :gui :bold}}
                                  :cond hide-in-width?
                                  :padding {:right 1}
                                  :separator ""}
                                 (border 0)]
                     :lualine_y []
                     :lualine_z []}
          :winbar {:lualine_a []
                   :lualine_b []
                   :lualine_c [(border {:right 1})
                               filename
                               {1 :navic :color {:gui :bold}}]}
          :inactive_winbar {:lualine_a []
                            :lualine_b []
                            :lualine_c [(border {:right 1})
                                        {1 :filename :padding 0}
                                        {1 :navic :color {:gui :bold}}]}})
  (functions.require-and :lualine #($.setup config)))

M
