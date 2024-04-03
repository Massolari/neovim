(local {: generate-code-image} (require :functions))

; Fechar todos os outros buffers
(vim.api.nvim_create_user_command :Bdall "%bd|e#|bd#"
                                  {:desc "Fechar todos os outros buffers"})

; Gerar imagem do código
(vim.api.nvim_create_user_command :Silicon generate-code-image
                                  {:range "%" :nargs "?"})
