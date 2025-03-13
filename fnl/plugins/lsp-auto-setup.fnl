(local {: dir-exists? : lsp-config-options} (require :functions))

{1 :Massolari/lsp-auto-setup.nvim
 :dependencies [:neovim/nvim-lspconfig]
 :opts {:server_config lsp-config-options}}
