require("plugins.nvim-dap")
vim.pack.add({ "https://github.com/igorlfs/nvim-dap-view" })

---@module 'dap-view'
---@type dapview.Config
require("dap-view").setup({
  winbar = { default_section = "scopes" },
  windows = { position = "right" },
})
