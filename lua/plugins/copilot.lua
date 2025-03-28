return {
  "github/copilot.vim",
  event = "VeryLazy",
  init = function()
    vim.g.copilot_filetypes = { gitcommit = true }
    vim.keymap.set("i", "<m-n>", "<Plug>(copilot-next)")
    vim.keymap.set("i", "<m-p>", "<Plug>(copilot-previous)")
    vim.keymap.set("i", "<c-;>", "<Plug>(copilot-suggest)")
  end,
}
