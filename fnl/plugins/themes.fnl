(local {: require-and} (require :functions))

[{1 :projekt0n/github-nvim-theme}
 {1 :catppuccin/nvim
  :name :catppuccin
  :lazy false
  :opts {:flavour :latte
         :integrations {:aerial true
                        :alpha true
                        :cmp true
                        :dashboard true
                        :flash true
                        :gitsigns true
                        :headlines true
                        :illuminate true
                        :indent_blankline {:enabled true}
                        :leap true
                        :lsp_trouble true
                        :mason true
                        :markdown true
                        :mini true
                        :native_lsp {:enabled true
                                     :underlines {:errors [:undercurl]
                                                  :hints [:undercurl]
                                                  :warnings [:undercurl]
                                                  :information [:undercurl]}}
                        :navic {:enabled true :custom_bg :lualine}
                        :neotest true
                        :neotree true
                        :noice true
                        :notify true
                        :semantic_tokens true
                        :telescope true
                        :treesitter true
                        :treesitter_context true
                        :which_key true}}
  :config (fn [{: opts}]
            (require-and :catppuccin #($.setup opts))
            (vim.cmd.colorscheme :catppuccin-latte))
  :priority 1000}
 {1 :maxmx03/solarized.nvim
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
  :lazy false
  :init (fn []
          (set vim.g.gruvbox_italic 1)
          (set vim.g.gruvbox_sign_column :bg0))}
 {1 :navarasu/onedark.nvim :opts {:style :light} :config true}]
