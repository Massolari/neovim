(require-macros :hibiscus.vim)

(local wilder (require :wilder))

(wilder.setup {:modes [":" "/" "?"]})

(wilder.set_option
  "pipeline"
  [(wilder.branch
    (wilder.python_file_finder_pipeline
      {:file_command ["fd" "-tf" "-H"]
       :dir_command ["fd" "-td" "-H"]})
    (wilder.substitute_pipeline
      {:pipeline
        (wilder.python_search_pipeline
          {:skip_cmdtype_check 1
           :pattern (wilder.python_fuzzy_pattern {:start_at_boundary 0})})})
    (wilder.cmdline_pipeline {:fuzzy 1})
    [(wilder.check (fn [_ x] (vim.fn.empty x)))
     (wilder.history)]
    (wilder.python_search_pipeline
      {:pattern (wilder.python_fuzzy_pattern {:start_at_boundary 0})}))])

(wilder.set_option
  "renderer"
  (wilder.popupmenu_renderer
    (wilder.popupmenu_border_theme
      {:highlighter (wilder.basic_highlighter)
       :highlights
        {:accent
          (wilder.make_hl
            "WilderAccent"
            "Pmenu"
            [{} {} {:foreground "#f4468f"}])
         :border "Normal"}
       :border "rounded"
       :left [" " (wilder.popupmenu_devicons)]
       :right [" " (wilder.popupmenu_scrollbar)]})))
