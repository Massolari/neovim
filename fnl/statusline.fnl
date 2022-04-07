(require-macros :hibiscus.vim)
(require-macros :hibiscus.core)

(fn get-file-path []
  (let [path (string.gsub (vim.fn.expand "%:h") "^./" "")
        formatted-cwd (string.gsub (vim.fn.getcwd) "\\-" "\\-")
        formatted-path (string.gsub path (.. formatted-cwd "/" ""))]
    (if (= formatted-path ".")
      ""
      (.. formatted-path "/"))))

(local functions (require :functions))

(local get-color functions.get-color)

(local colors
  {:bg (get-color "CursorLine" "bg" "#202328")
   :fg (get-color "Normal" "fg" "#bbc2cf")
   :yellow "DarkYellow"
   :cyan "#008080"
   :darkblue "#081633"
   :green "#98be65"
   :orange "#FF8800"
   :violet "#a9a1e1"
   :magenta "#c678dd"
   :blue "#51afef"
   :red "#ec5f67"})

(fn buffer-not-empty? []
  (~= 1 (vim.fn.empty (vim.fn.expand "%:t"))))

(fn hide-in-width? []
  (> (vim.fn.winwidth 0) 80))

(local config
  {:options
    {:disabled_filetypes ["dashboard"]
     :component_separators "·"
     :section_separators ""}
   :sections
    {:lualine_a {}
     :lualine_b {}
     :lualine_y {}
     :lualine_z {}
    ; These will be filled later
     :lualine_c {}
     :lualine_x {}}
    :inactive_sections
    ; these are to remove the defaults
    {:lualine_a {}
     :lualine_v {}
     :lualine_y {}
     :lualine_z {}
     :lualine_c {}
     :lualine_x {}}})

; Inserts a component in lualine_c at left section
(fn ins-left [component]
  (table.insert config.sections.lualine_c component))

(fn ins-inactive-left [component]
  (table.insert config.inactive_sections.lualine_c component))

; Inserts a component in lualine_x at left section
(fn ins-right [component]
  (table.insert config.sections.lualine_x component))

(fn ins-inactive-right [component]
  (table.insert config.inactive_sections.lualine_x component))

(ins-left
  {1 (fn [] "▊")
   :color {:fg colors.blue}
   :padding {:left 0 :right 1}
   :separator ""})

(ins-left
  {1 get-file-path
   :cond buffer-not-empty?
   :padding 0
   :color {:fg colors.magenta :gui "bold"}
   :separator ""})

(ins-left
  {1 "filetype"
   :icon_only true
   :padding {:left 0 :right 1}
   :separator ""})

(ins-left
  {1 "filename"
   :padding 0
   :color {:fg colors.magenta :gui "bold"}
   :separator ""})

(ins-left
  {1 (fn []
    (let [symbol-line (functions.symbol-line)
          current-function vim.b.coc_current_function]
      (if (~= symbol-line "")
        symbol-line
        (if (string? current-function) current-function ""))))
   :cond buffer-not-empty?
   :color {:fg colors.blue :gui "bold"}
   :padding {:left 1 :right 0}
   :separator ""})

(ins-left {1 "location" :padding {:left 1} :separator ""})
(ins-left {1 "progress" :padding {:left 0 :right 1} :color {:gui "bold"}})
(ins-left {1 "diagnostics" :symbols {:error " " :warn " " :info "  " :hint " "}})

(ins-right
  {1 #(or vim.g.coc_status "")
   :color {:fg colors.cyan}})

(ins-right {1 "branch" :icon " " :color {:fg colors.violet :gui "bold"} :separator ""})

(ins-right
  {1 "diff"
   :symbols {:added " " :modified "柳" :removed " "}
   :diff_color
     {:added {:fg colors.green}
      :modified {:fg colors.orange}
      :removed {:fg colors.red}}
   :cond hide-in-width?
   :padding {:right 1}
   :separator ""})

(ins-right
  {1 (fn [] "▊")
   :color {:fg colors.blue}
   :padding 0})

(ins-inactive-left
  {1 get-file-path
   :cond buffer-not-empty?
   :padding {:left 1 :right 0}
   :color {:gui "bold"}
   :separator ""})

(ins-inactive-left
  {1 "filetype"
   :icon_only true
   :padding {:left 0 :right 1}
   :separator ""})

(ins-inactive-left
  {1 "filename"
   :padding 0
   :color {:gui "bold"}
   :separator ""})

((. (require :lualine) "setup") config)
