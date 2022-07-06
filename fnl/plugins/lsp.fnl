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
                     {:virtual_text {:prefix :x}})))

(local capabilities (let [cmp-lsp (require :cmp_nvim_lsp)]
                      (-> (vim.lsp.protocol.make_client_capabilities)
                          (cmp-lsp.update_capabilities))))

(set lspconfig.util.default_config
     (vim.tbl_extend :force lspconfig.util.default_config
                     {: on_attach : capabilities}))

(each [_ server (ipairs (lsp-installer.get_installed_servers))]
  (let [s (. lspconfig server.name)]
    (s.setup {})))
