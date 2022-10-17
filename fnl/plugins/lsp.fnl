(require-macros :hibiscus.vim)

(local mason (require :mason))
(local mason-lspconfig (require :mason-lspconfig))
(local lspconfig (require :lspconfig))
(local lsp-status (require :lsp-status))
(local navic (require :nvim-navic))
(local wk (require :which-key))

(local border [["╭" :FloatBorder]
               ["─" :FloatBorder]
               ["╮" :FloatBorder]
               ["│" :FloatBorder]
               ["╯" :FloatBorder]
               ["─" :FloatBorder]
               ["╰" :FloatBorder]
               ["│" :FloatBorder]])

(lsp-status.register_progress)

(mason.setup {})
(mason-lspconfig.setup {})

(fn on_attach [client bufnr]
  (lsp-status.on_attach client)
  (navic.attach client bufnr)
  (set vim.lsp.handlers.textDocument/hover
       (vim.lsp.with vim.lsp.handlers.hover {: border}))
  (set vim.lsp.handlers.textDocument/signatureHelp
       (vim.lsp.with vim.lsp.handlers.signature_help {: border}))
  (set vim.lsp.handlers.textDocument/publishDiagnostics
       (vim.lsp.with vim.lsp.diagnostic.on_publish_diagnostics
                     {:virtual_text false})))

;; {:virtual_text {:prefix :x}})))

(fn apply-lsp-status-capabilities [capabilities]
  (vim.tbl_extend :keep capabilities lsp-status.capabilities))

(local capabilities (let [cmp-lsp (require :cmp_nvim_lsp)]
                      (-> (cmp-lsp.default_capabilities)
                          (apply-lsp-status-capabilities))))

(set lspconfig.util.default_config
     (vim.tbl_extend :force lspconfig.util.default_config
                     {: on_attach : capabilities}))

; Desativar virtual text porque estamos usando o plugin lsp_lines
(vim.diagnostic.config {:virtual_text false})
(λ get-config-options [server-name]
  (match server-name
    :sumneko_lua {:settings {:Lua {:runtime {:version :LuaJIT}
                                   :diagnostics {:globals [:vim]}
                                   :workspace {:library (vim.api.nvim_get_runtime_file ""
                                                                                       true)}}}}
    :grammarly {:root_dir (fn []
                            (vim.loop.os_homedir))}
    _ {}))

;; (each [_ server (ipairs (mason-lspconfig.get_installed_servers))]
;;   (let [s (. lspconfig server)]
;;     (-> server (get-config-options) (s.setup))))

(mason-lspconfig.setup_handlers [(fn [server-name]
                                   (let [server (. lspconfig server-name)]
                                     (-> server-name (get-config-options)
                                         (server.setup))))])

(lspconfig.elmls.setup {})
