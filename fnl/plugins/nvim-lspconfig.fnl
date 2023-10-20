(import-macros {: augroup!} :hibiscus.vim)
(local {: require-and : get-lsp-config-options} (require :functions))

(local M
       {1 :neovim/nvim-lspconfig
        :event :BufReadPost
        :dependencies [:mason.nvim
                       :williamboman/mason-lspconfig.nvim
                       :SmiteshP/nvim-navic]
        :init (fn []
                (set vim.lsp.set_log_level :trace)
                (require-and :vim.lsp.log #($.set_format_func vim.inspect)))})

(fn M.on_attach [client bufnr]
  (local capabilities client.server_capabilities)
  (when capabilities.documentSymbolProvider
    (local navic (require :nvim-navic))
    (navic.attach client bufnr))
  (when capabilities.codeLensProvider
    (augroup! :_code_lens
              [[:BufEnter :CursorHold :InsertLeave]
               `(buffer 0)
               #(vim.lsp.codelens.refresh)]))
  (when capabilities.inlayHintProvider
    (vim.lsp.inlay_hint 0 true))
  (set vim.lsp.handlers.textDocument/publishDiagnostics
       (vim.lsp.with vim.lsp.diagnostic.on_publish_diagnostics
         {:virtual_text false})))

(fn M.config []
  (local mason (require :mason))
  (local mason-lspconfig (require :mason-lspconfig))
  (local lspconfig (require :lspconfig))
  (local capabilities (require-and :cmp_nvim_lsp #($.default_capabilities)))
  (set lspconfig.util.default_config
       (vim.tbl_extend :force lspconfig.util.default_config
                       {:on_attach M.on_attach : capabilities}))
  ;; Desativar virtual text porque estamos usando o plugin lsp_lines
  (vim.diagnostic.config {:virtual_text false})
  (mason.setup {})
  (mason-lspconfig.setup {})
  (mason-lspconfig.setup_handlers [(fn [server-name]
                                     (let [server (. lspconfig server-name)]
                                       (-> server-name
                                           (get-lsp-config-options server.document_config.default_config)
                                           (server.setup))))])
  (lspconfig.nimls.setup {})
  (lspconfig.hls.setup {})
  (lspconfig.gleam.setup {}))

M
