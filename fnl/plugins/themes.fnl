(local {: require-and} (require :functions))

[{1 :projekt0n/github-nvim-theme :enabled false}
 {1 :catppuccin/nvim
  :name :catppuccin
  :lazy false
  :opts {:flavour :latte}
  :config (fn [{: opts}]
            (require-and :catppuccin #($.setup opts))
            (vim.cmd.colorscheme :catppuccin-latte))
  :priority 1000}
 {1 :maxmx03/solarized.nvim
  :enabled false
  :lazy false
  :priority 1000
  :config (fn []
            (require-and :solarized
                         #($.setup {:theme :neo
                                    :highlights (fn [colors {: lighten}]
                                                  {:IndentBlanklineChar {:fg (lighten colors.base01
                                                                                      50)}
                                                   :IndentBlanklineContextChar {:fg colors.base01}})}))
            {})}
 {1 :ellisonleao/gruvbox.nvim
  :enabled false
  :lazy false
  :init (fn []
          (set vim.g.gruvbox_italic 1)
          (set vim.g.gruvbox_sign_column :bg0))}
 {1 :navarasu/onedark.nvim :enabled false :opts {:style :light} :config true}]
