local functions = require("functions")

-- local plugin_dir = vim.g.local_plugins_dir .. "/lsp-auto-setup.nvim"

return {
  "Massolari/lsp-auto-setup.nvim",
  -- cond = functions.dir_exists(plugin_dir),
  -- dir = plugin_dir,
  event = "BufRead",
  dependencies = { "neovim/nvim-lspconfig" },
  opts = { server_config = functions.lsp_config_options },
}
