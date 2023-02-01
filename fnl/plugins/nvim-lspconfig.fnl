(local {: requireAnd} (require :functions))
(local M {1 :neovim/nvim-lspconfig
          :event :BufReadPost
          :dependencies [:mason.nvim
                         :williamboman/mason-lspconfig.nvim
                         :SmiteshP/nvim-navic]})

(fn M.config []
  (local mason (require :mason))
  (local mason-lspconfig (require :mason-lspconfig))
  (local lspconfig (require :lspconfig))
  (local lspconfig-configs (require :lspconfig.configs))
  (local navic (require :nvim-navic))
  (local border [["╭" :FloatBorder]
                 ["─" :FloatBorder]
                 ["╮" :FloatBorder]
                 ["│" :FloatBorder]
                 ["╯" :FloatBorder]
                 ["─" :FloatBorder]
                 ["╰" :FloatBorder]
                 ["│" :FloatBorder]])

  (fn on_attach [client bufnr]
    (navic.attach client bufnr)
    (set vim.lsp.handlers.textDocument/hover
         (vim.lsp.with vim.lsp.handlers.hover {: border}))
    (set vim.lsp.handlers.textDocument/signatureHelp
         (vim.lsp.with vim.lsp.handlers.signature_help {: border}))
    (set vim.lsp.handlers.textDocument/publishDiagnostics
         (vim.lsp.with vim.lsp.diagnostic.on_publish_diagnostics
                       {:virtual_text false})))

  ;; {:virtual_text {:prefix :x}})))
  (local capabilities (requireAnd :cmp_nvim_lsp #($.default_capabilities)))
  (set lspconfig.util.default_config
       (vim.tbl_extend :force lspconfig.util.default_config
                       {: on_attach : capabilities}))
  ;; Desativar virtual text porque estamos usando o plugin lsp_lines
  (vim.diagnostic.config {:virtual_text false})
  (λ get-config-options [server-name]
    (match server-name
      :sumneko_lua {:settings {:Lua {:runtime {:version :LuaJIT}
                                     :diagnostics {:globals [:vim]}
                                     :workspace {:library (vim.api.nvim_get_runtime_file ""
                                                                                         true)}}}}
      :grammarly {:root_dir vim.loop.cwd}
      :ltext {:root_dir vim.loop.cwd}
      _ {}))
  (mason.setup {})
  (mason-lspconfig.setup {})
  (mason-lspconfig.setup_handlers [(fn [server-name]
                                     (let [server (. lspconfig server-name)]
                                       (-> server-name (get-config-options)
                                           (server.setup))))])
  (set lspconfig-configs.fennel_language_server
       {:default_config {:cmd [(.. (vim.fn.getenv :HOME)
                                   :/.cargo/bin/fennel-language-server)]
                         :filetypes [:fennel]
                         :single_file_support true
                         :root_dir (lspconfig.util.root_pattern :fnl)
                         :settings {:fennel {:workspace {:library (vim.api.nvim_list_runtime_paths)}
                                             :diagnostics {:globals [:vim]}}}}})
  (lspconfig.fennel_language_server.setup {})
  (lspconfig.gleam.setup {})
  (lspconfig.nimls.setup {}))

M
