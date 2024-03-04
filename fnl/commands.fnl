(local {: generate-code-image} (require :functions))

(vim.api.nvim_create_user_command :Silicon #(generate-code-image $)
                                  {:range "%" :nargs "?"})
