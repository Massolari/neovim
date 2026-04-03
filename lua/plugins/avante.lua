local functions = require("functions")

functions.on_pack_changed("avante.nvim", function(ev)
  vim.system({ "make" }, { cwd = ev.data.path })
end)

require("plugins.plenary")
require("plugins.fzf-lua")
require("plugins.nvim-web-devicons")
require("plugins.render-markdown")
vim.pack.add({
  "https://github.com/stevearc/dressing.nvim",
  "https://github.com/MunifTanjim/nui.nvim",
  "https://github.com/ravitemer/mcphub.nvim",

  "https://github.com/yetone/avante.nvim",
})

require("avante").setup({
  provider = "copilot",
  providers = {
    copilot = {
      model = "claude-opus-4.6",
    },
  },
  system_prompt = function()
    local hub = require("mcphub").get_hub_instance()
    return hub and hub:get_active_servers_prompt() or ""
  end,
  custom_tools = function()
    return {
      require("mcphub.extensions.avante").mcp_tool(),
    }
  end,
  disabled_tools = {
    "list_files", -- Built-in file operations
    "search_files",
    "read_file",
    "create_file",
    "rename_file",
    "delete_file",
    "create_dir",
    "rename_dir",
    "delete_dir",
    "bash", -- Built-in terminal access
  },
})
