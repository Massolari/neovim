local notify = require("notify")

vim.pack.add({ "https://github.com/ThePrimeagen/harpoon" })
require("harpoon").setup()

vim.keymap.set("n", "<leader><space>", function()
  require("harpoon.mark").add_file()
  notify.info("Arquivo marcado", "Harpoon")
end, { desc = "Marcar arquivo com harpoon" })

vim.keymap.set("n", "<leader>ph", function()
  return require("harpoon.ui").toggle_quick_menu()
end, { desc = "Mostrar marcas do harpoon" })

for _, n in ipairs({ 1, 2, 3, 4, 5, 6, 7, 8, 9, 0 }) do
  vim.keymap.set("n", "<leader>" .. n, function()
    return require("harpoon.ui").nav_file(n)
  end, { desc = "Ir para marca " .. n .. " do harpoon" })
end
