(import-macros {: augroup!} :hibiscus.vim)
(local {: require-and : get-lsp-config-options} (require :functions))

(local server-blacklist [:contextive
                         :custom_elements_ls
                         :efm
                         :snyk_ls
                         :diagnosticls
                         :fennel_ls
                         :typos_lsp])

(λ setup-server [name]
  (let [lspconfig (require :lspconfig)
        server (. lspconfig name)]
    (-> name
        (get-lsp-config-options server.document_config.default_config)
        (server.setup))))

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
    (augroup! :_code_lens
              [[:BufEnter :CursorHold :InsertLeave]
               `(buffer 0)
               #(vim.lsp.codelens.refresh)]))
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
                                    :/lazy/nvim-lspconfig/lua/lspconfig/server_configurations))]
    (when (= type_ :file)
      (let [name-without-extension (string.sub name 0 -5)
            is-blacklisted (vim.tbl_contains server-blacklist
                                             name-without-extension)]
        (when (not is-blacklisted)
          (setup-server name-without-extension))))))

M
