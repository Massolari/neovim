(local {: on_attach} (require :plugins.nvim-lspconfig))

{1 :pmizio/typescript-tools.nvim
 :dependencies [:nvim-lua/plenary.nvim :neovim/nvim-lspconfig]
 :opts {: on_attach
        :settings {:tsserver_file_preferences {:includeInlayParameterNameHints :all
                                               :includeInlayParameterNameHintsWhenArgumentMatchesName true
                                               :includeInlayFunctionParameterTypeHints true
                                               :includeInlayVariableTypeHints true
                                               :includeInlayVariableTypeHintsWhenTypeMatchesName true
                                               :includeInlayPropertyDeclarationTypeHints true
                                               :includeInlayFunctionLikeReturnTypeHints true
                                               :includeInlayEnumMemberValueHints true}}}}
