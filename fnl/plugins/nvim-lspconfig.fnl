(local {: require-and : get-lsp-config-options} (require :functions))

(λ setup-server [name]
  (let [lspconfig (require :lspconfig)
        server (. lspconfig name)
        default_config (or server.default_config
                           server.document_config.default_config)
        options (get-lsp-config-options name default_config)
        cmd (match (type default_config.cmd)
              :table (-> options.cmd
                         (or default_config.cmd)
                         (. 1)
                         (or ""))
              :string default_config.cmd
              _ "")]
    (when (= 1 (vim.fn.executable cmd))
      (server.setup options))))

(local M
       {1 :neovim/nvim-lspconfig
        :event :BufReadPost
        :dependencies [:mason.nvim :SmiteshP/nvim-navic]
        :init (fn []
                (set vim.lsp.set_log_level :trace)
                (require-and :vim.lsp.log #($.set_format_func vim.inspect)))})

(fn M.on_attach [client bufnr]
  (local capabilities client.server_capabilities)
  (when capabilities.documentSymbolProvider
    (local navic (require :nvim-navic))
    (navic.attach client bufnr))
  (when capabilities.codeLensProvider
    (vim.api.nvim_create_autocmd [:BufEnter :CursorHold :InsertLeave]
                                 {:buffer 0
                                  :callback #(vim.lsp.codelens.refresh {:bufnr 0})
                                  :group (vim.api.nvim_create_augroup :_code_lens
                                                                      {})}))
  (when capabilities.inlayHintProvider
    (vim.lsp.inlay_hint.enable))
  (set vim.lsp.handlers.textDocument/publishDiagnostics
       (vim.lsp.with vim.lsp.diagnostic.on_publish_diagnostics
         {:virtual_text false})))

(fn M.config []
  (local mason (require :mason))
  (local lspconfig (require :lspconfig))
  (local capabilities
         (let [cmp_capabilities (require-and :cmp_nvim_lsp
                                             #($.default_capabilities))]
           (vim.tbl_extend :force cmp_capabilities
                           (vim.lsp.protocol.make_client_capabilities))))
  (set lspconfig.util.default_config
       (vim.tbl_extend :force lspconfig.util.default_config
                       {:on_attach M.on_attach : capabilities}))
  ;; Desativar virtual text porque estamos usando o plugin lsp_lines
  (vim.diagnostic.config {:virtual_text false})
  (mason.setup {})
  (each [name type_ (vim.fs.dir (.. (vim.fn.stdpath :data)
                                    :/lazy/nvim-lspconfig/lua/lspconfig/configs))]
    (when (= type_ :file)
      (let [name-without-extension (string.sub name 0 -5)]
        (setup-server name-without-extension)))))

M

