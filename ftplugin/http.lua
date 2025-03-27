local kulala = require("kulala")

vim.keymap.set("n", "<localleader>r", function()
  kulala.run()
end, { desc = "Executar a requisição" })

vim.keymap.set("n", "<localleader>i", function()
  kulala.inspect()
end, { desc = "Inspeccionar a requisição" })

vim.keymap.set("n", "]", function()
  kulala.jump_next()
end)

return vim.keymap.set("n", "[", function()
  kulala.jump_prev()
end)

