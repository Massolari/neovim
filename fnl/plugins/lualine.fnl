(local M {1 :nvim-lualine/lualine.nvim
          :cond (not vim.g.started_by_firenvim)
          :event :VimEnter
          :dependencies [:kyazdani42/nvim-web-devicons]})

(fn get-file-path []
  (let [path (string.gsub (vim.fn.expand "%:h") "^./" "")
        formatted-cwd (string.gsub (vim.fn.getcwd) "\\-" "\\-")
        formatted-path (string.gsub path (.. formatted-cwd "/") "")]
    (if (= formatted-path ".") "" (.. formatted-path "/"))))

(local {: get-color : require-and} (require :functions))

(local get-color get-color)

(fn get-background-color []
  (let [query #(get-color :CursorLine $1 false)
        guibg (query :guibg)
        bg (query :bg)]
    (or guibg bg "")))

(local colors {:bg (get-background-color)
               :fg (get-color :Normal :fg "#bbc2cf")
               :yellow :DarkYellow
               :cyan "#008080"
               :darkblue "#081633"
               :green "#98be65"
               :orange "#FF8800"
               :violet "#a9a1e1"
               :magenta "#c678dd"
               :blue "#51afef"
               :red "#ec5f67"})

(fn buffer-not-empty? []
  (not= 1 (vim.fn.empty (vim.fn.expand "%:t"))))

(fn hide-in-width? []
  (> (vim.fn.winwidth 0) 80))

(fn M.config []
  (local config {:options {:disabled_filetypes [:dashboard]
                           :component_separators "·"
                           :globalstatus (= (vim.opt.laststatus:get) 3)
                           :section_separators ""}
                 :sections {:lualine_a {}
                            :lualine_b {}
                            :lualine_y {}
                            :lualine_z {}
                            ; These will be filled later
                            :lualine_c {}
                            :lualine_x {}}
                 :inactive_sections ; these are to remove the defaults
                 {:lualine_a {}
                                     :lualine_v {}
                                     :lualine_y {}
                                     :lualine_z {}
                                     :lualine_c {}
                                     :lualine_x {}}}) ; Inserts a component in lualine_c at left section
  (λ ins-left [component]
    (table.insert config.sections.lualine_c component))
  (λ ins-inactive-left [component]
    (table.insert config.inactive_sections.lualine_c component)) ; Inserts a component in lualine_x at right section
  (λ ins-right [component]
    (table.insert config.sections.lualine_x component))
  (λ ins-inactive-right [component]
    (table.insert config.inactive_sections.lualine_x component))
  (ins-left {1 (fn []
                 "▊")
             :color {:fg colors.blue}
             :padding {:left 0 :right 1}
             :separator ""})
  (ins-left {1 get-file-path
             :cond buffer-not-empty?
             :padding 0
             :color {:fg colors.magenta :gui :bold}
             :separator ""})
  (ins-left {1 :filetype
             :icon_only true
             :padding {:left 0 :right 1}
             :separator ""})
  (ins-left {1 :filename
             :padding {:left 0 :right 1}
             :color {:fg colors.magenta :gui :bold}})
  (ins-left {1 :location :padding {:left 1} :separator ""})
  (ins-left {1 :progress
             :padding {:left 1 :right 1}
             :color {:gui :bold}
             :separator ""})
  (ins-left {1 :diagnostics
             :symbols {:error " " :warn " " :info "  " :hint " "}
             :separator ""})
  (ins-left {1 #(let [noice (require :noice)]
                  (noice.api.status.mode.get))
             :cond #(let [noice (require :noice)]
                      (noice.api.status.mode.has))
             :separator ""})
  (ins-left {1 (fn []
                 "%=")
             :separator ""})
  (ins-left {1 (fn []
                 (let [clients (vim.lsp.buf_get_clients)
                       buf-filetype (vim.api.nvim_buf_get_option 0 :filetype)
                       result []]
                   (each [_ client (pairs clients)]
                     (let [client-filetypes (or client.config.filetypes [])]
                       (when (->> buf-filetype
                                  (vim.fn.index client-filetypes)
                                  (not= -1))
                         (table.insert result client.name))))
                   (if (> (length result) 0)
                       (.. "  LSP: " (table.concat result " | "))
                       "No Active Lsp")))
             :cond buffer-not-empty?})
  (ins-right {1 #(let [noice (require :noice)]
                   (-> (noice.api.status.search.get)
                       (string.gsub "W " "⤴ ")))
              :cond #(let [noice (require :noice)]
                       (noice.api.status.search.has))
              :separator ""})
  (ins-right {1 :branch
              :icon " "
              :color {:fg colors.violet :gui :bold}
              :separator ""})
  (ins-right {1 :diff
              :symbols {:added " " :modified "柳" :removed " "}
              :diff_color {:added {:fg colors.green}
                           :modified {:fg colors.orange}
                           :removed {:fg colors.red}}
              :cond hide-in-width?
              :padding {:right 1}
              :separator ""})
  (ins-right {1 (fn []
                  "▊")
              :color {:fg colors.blue}
              :padding 0})
  (ins-inactive-left {1 get-file-path
                      :cond buffer-not-empty?
                      :padding {:left 1 :right 0}
                      :color {:gui :bold}
                      :separator ""})
  (ins-inactive-left {1 :filetype
                      :icon_only true
                      :padding {:left 0 :right 1}
                      :separator ""})
  (ins-inactive-left {1 :filename :padding 0 :color {:gui :bold} :separator ""})
  (require-and :lualine #($.setup config))
  (require :winbar))

M
