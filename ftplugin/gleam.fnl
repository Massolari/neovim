(set vim.opt.shiftwidth 2)
(vim.lsp.start {:name :glas
                :cmd [(.. vim.env.HOME
                          :/.vscode/extensions/maurobalbi.glas-vscode-0.0.6-darwin-arm64/glas)
                      :--stdio]
                :root_dir (vim.fs.dirname (. (vim.fs.find [:gleam.toml]
                                                          {:upward true})
                                             1))})
