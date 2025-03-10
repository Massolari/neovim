{1 :folke/noice.nvim
 :cond (not vim.g.started_by_firenvim)
 :event :VeryLazy
 :dependencies [:MunifTanjim/nui.nvim]
 :opts {:presets {:lsp_doc_border true}
        :lsp {:hover {:enabled true}
              :signature {:enabled true}
              :override {;; override the default lsp markdown formatter with Noice
                         :vim.lsp.util.convert_input_to_markdown_lines true
                         ;; override the lsp markdown formatter with Noice
                         :vim.lsp.util.stylize_markdown true
                         ;; override cmp documentation with Noice (needs the other options to work)
                         :cmp.entry.get_documentation true}}}}

