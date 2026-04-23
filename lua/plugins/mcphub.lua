require("plugins.plenary")
require("plugins.copilotchat")

vim.pack.add({
  {
    src = "https://github.com/ravitemer/mcphub.nvim",
    data = {
      build = {
        run = function(_)
          vim.system({ "npm", "install", "-g", "mcp-hub@latest" })
        end,
      },
    },
  },
})

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
