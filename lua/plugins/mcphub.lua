--- @type LazyPluginSpec
return {
  "ravitemer/mcphub.nvim",
  dependencies = { "CopilotC-Nvim/CopilotChat.nvim", "nvim-lua/plenary.nvim" },
  build = "npm install -g mcp-hub@latest", -- Installs `mcp-hub` node binary globally
  config = function()
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
  end,
}
