(local functions (require :functions))

(set vim.lsp.set_log_level :trace)
(set vim.lsp.log vim.inspect)

(fn on_attach [client bufnr]
  (when (client:supports_method :textDocument/documentSymbol)
    (functions.require-and :nvim-navic #($.attach client bufnr)))
  (when (client:supports_method :textDocument/completion)
    (set client.server_capabilities.completionProvider.completionItem.snippetSupport
         true))
  (when (client:supports_method :textDocument/codeLens)
    (vim.api.nvim_create_autocmd [:BufEnter :CursorHold :InsertLeave]
                                 {:buffer 0
                                  :callback #(vim.lsp.codelens.refresh {:bufnr 0})
                                  :group (vim.api.nvim_create_augroup :_code_lens
                                                                      {})}))
  (when (client:supports_method :textDocument/inlayHint)
    (vim.lsp.inlay_hint.enable)))

;; :help LspAttach
(set vim.lsp.handlers.client/registerCapability
     ((fn [overriden]
        (fn [err res ctx]
          (let [result (overriden err res ctx)
                client (vim.lsp.get_client_by_id ctx.client_id)]
            (when client
              (on_attach client vim.api.nvim_get_current_buf)
              result)))) vim.lsp.handlers.client/registerCapability))
