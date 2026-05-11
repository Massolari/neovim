vim.pack.add({ "https://github.com/nvim-mini/mini.nvim" })

require("mini.ai").setup({
  mappings = {
    around_next = "aN",
    inside_next = "iN",
  },
})

require("mini.surround").setup({
  mappings = {
    add = "Sa",
    delete = "Sd",
    find = "S>",
    find_left = "S<",
    highlight = "S!",
    replace = "Sc",
  },
})

vim.keymap.set("n", "S", "<Nop>")
