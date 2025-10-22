local functions = require("functions")

-- Fechar todos os buffers exceto o atual
vim.api.nvim_create_user_command("Bdall", "%bd|e#|bd#", { desc = "Fechar todos os outros buffers" })

-- Gerar imagem do código
vim.api.nvim_create_user_command("Silicon", functions.generate_code_image, { range = "%", nargs = "?" })

-- Mostrar histórico de notificações
vim.api.nvim_create_user_command("Notifications", function()
  Snacks.notifier.show_history()
end, {})
