(import-macros {: g!} :hibiscus.vim)

[{1 :projekt0n/github-nvim-theme}
 {1 :catppuccin/nvim :name :catppuccin :lazy false :priority 1000}
 {1 :maxmx03/solarized.nvim
  ; :lazy false
  ; :priority 1000
  :config (fn [] ; (require-and :solarized ;              #($.setup {:theme :neo ;                         :highlights (fn [colors {: lighten}]
            ;                                       {:IndentBlanklineChar {:fg (lighten colors.base01
            ;                                                                           50)}
            ;                                        :IndentBlanklineContextChar {:fg colors.base01}})}))
            {})}
 {1 :ellisonleao/gruvbox.nvim
  :lazy true
  :init (fn []
          (g! :gruvbox_italic 1)
          (g! :gruvbox_sign_column :bg0))}]
