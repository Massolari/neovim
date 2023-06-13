(local M {})

; (local servers {:tsserver [:nodePackages.typescript-language-server]
;                 :elmls [:elmPackages.elm-language-server :elmPackages.elm-format]
;                 :intelephense [:nodePackages.intelephense]
;                 :eslint [:nodePackages.vscode-langservers-extracted
;                          :nodePackages.eslint]})
(local servers {:elmls [:elmPackages.elm-language-server
                        :elmPackages.elm-format]})

(fn setup-servers []
  (local lspconfig (require :lspconfig))
  (each [server packages (pairs servers)]
    (let [lspconfig-server (. lspconfig server)
          nix-shell-command (icollect [_ p (pairs packages)]
                              (.. "nixpkgs#" p))
          cmd (vim.tbl_flatten [:nix :shell nix-shell-command :-c])
          default-cmd lspconfig-server.document_config.default_config.cmd]
      (each [_ d-cmd (pairs default-cmd)]
        (table.insert cmd d-cmd))
      ;; (vim.pretty_print cmd)
      (lspconfig-server.setup {: cmd}))))

;; Null-ls sources

; (local null-sources {:fnlfmt :fnlfmt})
(local null-sources {})

(λ make-source [null source package]
  (let [null-source (. null.builtins.formatting source)
        default-cmd null-source._opts.command
        default-args null-source._opts.args
        source-args #(vim.tbl_flatten [:shell
                                       (.. "nixpkgs#" package)
                                       :-c
                                       default-cmd
                                       $])]
    (set null-source._opts.command :nix)
    (set null-source._opts.args
         (if (= (type default-args) :function)
             #(source-args (default-args $1))
             (source-args default-args)))
    null-source))

(fn M.null-ls-sources []
  (local null (require :null-ls))
  (icollect [source package (pairs null-sources)]
    (make-source null source package)))

(λ M.setup []
  (setup-servers))

M
