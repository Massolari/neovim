vim.pack.add({ "https://github.com/stevearc/oil.nvim" })
require("oil").setup({
  columns = {
    "mtime",
    "size",
    "icon",
  },
  buf_options = {
    buflisted = true,
    bufhidden = "wipe",
  },
  view_options = {
    show_hidden = true,
  },
  keymaps = {
    ["H"] = { "actions.parent", mode = "n" },
    ["L"] = { "actions.select", mode = "n" },
    ["<BS>"] = { "actions.open_cwd", mode = "n" },
    ["<c-t>"] = { "actions.open_terminal", mode = "n" },
  },
})

vim.keymap.set("n", "<leader>ef", "<cmd>Oil<CR>", { desc = "Explorador de arquivos" })
