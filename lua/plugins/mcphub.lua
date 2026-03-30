local functions = require("functions")

require("plugins.plenary")
require("plugins.copilotchat")

functions.on_pack_changed("mcphub.nvim", function(_)
  vim.system({ "npm", "install", "-g", "mcp-hub@latest" })
end)

vim.pack.add({ "https://github.com/ravitemer/mcphub.nvim" })

require("mcphub").setup({
  extensions = {
    copilotchat = {
      enabled = true,
      convert_tools_to_functions = true,
      convert_resources_to_functions = true,
      add_mcp_prefix = true,
    },
  },
})
