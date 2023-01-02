{1 :folke/noice.nvim
 :event :VeryLazy
 :dependencies [:MunifTanjim/nui.nvim :rcarriga/nvim-notify]
 :config {:override {;; override the default lsp markdown formatter with Noice
                     :vim.lsp.util.convert_input_to_markdown_lines true
                     ;; override the lsp markdown formatter with Noice
                     :vim.lsp.util.stylize_markdown true
                     ;; override cmp documentation with Noice (needs the other options to work)
                     :cmp.entry.get_documentation false}
          :presets {:lsp_doc_border false}
          :lsp {:hover {:enabled false}
                :signature {:enabled false}
                :message {:view :mini}}
          :messages {:view :mini :view_error :mini :view_warn :mini}
          :notify {:view :mini}}}

;; (local noice (require :noice))
;;
;; (noice.setup {:override {;; override the default lsp markdown formatter with Noice
;;                          :vim.lsp.util.convert_input_to_markdown_lines true
;;                          ;; override the lsp markdown formatter with Noice
;;                          :vim.lsp.util.stylize_markdown true
;;                          ;; override cmp documentation with Noice (needs the other options to work)
;;                          :cmp.entry.get_documentation false}
;;               :presets {:lsp_doc_border false}
;;               :lsp {:hover {:enabled false}
;;                     :signature {:enabled false}
;;                     :message {:view :mini}}
;;               :messages {:view :mini :view_error :mini :view_warn :mini}
;;               :notify {:view :mini}})
