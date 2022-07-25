(require-macros :hibiscus.vim)

(local lsp-installer (require :nvim-lsp-installer))
(local lspconfig (require :lspconfig))
(local wk (require :which-key))

(local border [["┌" :FloatBorder]
               ["─" :FloatBorder]
               ["┐" :FloatBorder]
               ["│" :FloatBorder]
               ["┘" :FloatBorder]
               ["─" :FloatBorder]
               ["└" :FloatBorder]
               ["│" :FloatBorder]])

(lsp-installer.setup {})

(fn on_attach [client bufnr]
  (set vim.lsp.handlers.textDocument/hover
       (vim.lsp.with vim.lsp.handlers.hover {: border}))
  (set vim.lsp.handlers.textDocument/signatureHelp
       (vim.lsp.with vim.lsp.handlers.signature_help {: border}))
  (set vim.lsp.handlers.textDocument/publishDiagnostics
       (vim.lsp.with vim.lsp.diagnostic.on_publish_diagnostics
                     {:virtual_text false})))

;; {:virtual_text {:prefix :x}})))

(local capabilities (let [cmp-lsp (require :cmp_nvim_lsp)]
                      (-> (vim.lsp.protocol.make_client_capabilities)
                          (cmp-lsp.update_capabilities))))

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
    _ {}))

(each [_ server (ipairs (lsp-installer.get_installed_servers))]
  (let [s (. lspconfig server.name)]
    (-> server.name (get-config-options) (s.setup))))

(lspconfig.hls.setup {})
