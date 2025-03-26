(local functions (require :functions))

(local M {1 :neovim/nvim-lspconfig
          :event :BufReadPost
          :dependencies [:mason.nvim :SmiteshP/nvim-navic]
          :config (fn []
                    (functions.require-and :mason #($.setup {})))})

M
