(import-macros {: command!} :hibiscus.vim)
(local {: generate-code-image} (require :functions))

; Fechar todos os outros buffers
(command! [] :Bdall "%bd|e#|bd#")

; Cor de fundo transparente
(command! [] :Transparent "hi Normal guibg=NONE ctermbg=NONE")

(vim.api.nvim_create_user_command :Silicon #(generate-code-image $)
                                  {:range "%" :nargs "?"})
