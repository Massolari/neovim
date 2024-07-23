(local {: diagnostic-icon} (require :constants))
(local {: require-and} (require :functions))

(local M {1 :nvim-lualine/lualine.nvim
          :cond (not vim.g.started_by_firenvim)
          :event :VimEnter
          :dependencies [{1 :nvim-tree/nvim-web-devicons
                          :dir (.. vim.env.HOME :/nvim-web-devicons)}
                         {1 :ColinKennedy/nvim-gps :config true}]})

; -- show breadcrumbs if available
; local function breadcrumbs()
;   local items = vim.b.coc_nav
;   local t = {''}
;   for k,v in ipairs(items) do
;     setmetatable(v, { __index = function(table, key)
;       return ' '
;     end})
;     t[#t+1] = ' %#' .. (v.highlight or "Normal") .. '#' .. (type(v.label) == 'string' and v.label .. ' ' or '') .. '%#NonText#'.. (v.name or '')
;     if next(items,k) ~= nil then
;       t[#t+1] = '%#StatusLineNC# '
;     end
;   end
;   t[#t+1] = '%#EndOfBuffer#%L  '
;   return table.concat(t)
; end

(fn breadcrumbs []
  (let [items vim.b.coc_nav
        t [""]]
    (each [k v (ipairs items)]
      (setmetatable v {:__index (fn [_table _key] " ")})
      (tset t (+ 1 (length t))
            (.. " %#" (or v.highlight :Normal) "#"
                (if (= (type v.label) :string)
                    (.. v.label " ")
                    "") "%#NonText#" (or v.name "")))
      (when (not= (next items k) nil)
        (tset t (+ 1 (length t)) "%#StatusLineNC# ")))
    (tset t (+ 1 (length t)) "%#EndOfBuffer#%L  ")
    (table.concat t)))

(fn get-file-path []
  (let [path (string.gsub (vim.fn.expand "%:h") "^./" "")
        formatted-cwd (string.gsub (vim.fn.getcwd) "\\-" "\\-")
        formatted-path (string.gsub path (.. formatted-cwd "/") "")]
    (if (= formatted-path ".") "" (.. formatted-path "/"))))

(fn buffer-not-empty? []
  (not= 1 (vim.fn.empty (vim.fn.expand "%:t"))))

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

(local fileName {1 :filename :padding 0 :color {:fg colors.magenta :gui :bold}})

(fn M.config []
  (local gps (require :nvim-gps))
  (local config
         {:options {:disabled_filetypes [:dashboard]
                    :component_separators "·"
                    :globalstatus (= (vim.opt.laststatus:get) 3)
                    :section_separators ""}
          ; Os [] são para remover os componentes padrão
          :sections {:lualine_a []
                     :lualine_b []
                     :lualine_c [(border {:right 1})
                                 {1 get-file-path
                                  :cond buffer-not-empty?
                                  :padding 0
                                  :color {:fg colors.magenta :gui :bold}
                                  :separator ""}
                                 {1 :filetype
                                  :icon_only true
                                  :padding 0
                                  :separator ""}
                                 fileName
                                 {1 :location :padding {:left 1} :separator ""}
                                 {1 :progress
                                  :padding {:left 1 :right 1}
                                  :color {:gui :bold}
                                  :separator ""}
                                 {1 :diagnostics
                                  :symbols {:error diagnostic-icon.error
                                            :warn diagnostic-icon.warning
                                            :info diagnostic-icon.info
                                            :hint diagnostic-icon.hint}
                                  :separator ""}
                                 [:mode]
                                 ; {1 #(require-and :noice
                                 ;                  #($.api.status.mode.get))
                                 ;  :cond #(require-and :noice
                                 ;                      #($.api.status.mode.has))
                                 ;  :separator ""}
                                 {1 (fn [] "%=") :separator ""}
                                 {1 (fn []
                                      (let [filetype vim.bo.filetype
                                            services (->> (vim.fn.CocAction :services)
                                                          (vim.tbl_filter #(and (= $.state
                                                                                   :running)
                                                                                (vim.tbl_contains $.languageIds
                                                                                                  filetype)))
                                                          (vim.tbl_map #(string.gsub $.id
                                                                                     :languageserver.
                                                                                     "")))]
                                        (if (> (length services) 0)
                                            (.. "  LSP: "
                                                (table.concat services " | "))
                                            "No Active Lsp")))
                                  :cond buffer-not-empty?}
                                 ; {1 (fn []
                                 ;      (let [clients (vim.lsp.buf_get_clients)
                                 ;            buffer (vim.api.nvim_get_current_buf)
                                 ;            result []]
                                 ;        (each [_ client (pairs clients)]
                                 ;          (when (->> buffer
                                 ;                     (. client.attached_buffers)
                                 ;                     (= true))
                                 ;            (table.insert result client.name)))
                                 ;        (if (> (length result) 0)
                                 ;            (.. "  LSP: "
                                 ;                (table.concat result " | "))
                                 ;            "No Active Lsp")))
                                 ;  :cond buffer-not-empty?}
                                 ]
                     :lualine_x [; {1 #(require-and :noice
                                 ;                  #(-> ($.api.status.search.get)
                                 ;                       (string.gsub "W " "⤴ ")))
                                 ;  :cond #(require-and :noice
                                 ;                      #($.api.status.search.has))
                                 ;  :separator ""}
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
                               fileName
                               {1 #(gps.get_location)
                                :cond #(gps.is_available)
                                :color {:gui :bold}}]}
          :inactive_winbar {:lualine_a []
                            :lualine_b []
                            :lualine_c [(border {:right 1})
                                        {1 :filename :padding 0}
                                        {1 #(gps.get_location)
                                         :cond #(gps.is_available)
                                         :color {:gui :bold}}]}})
  (require-and :lualine #($.setup config)))

M

