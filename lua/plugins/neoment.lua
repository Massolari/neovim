local functions = require("functions")

local plugin_dir = vim.g.local_plugins_dir .. "/neoment.nvim"

return {
  "Massolari/neoment.nvim",
  dir = functions.dir_exists(plugin_dir) and plugin_dir or nil,
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    vim.g.neoment = {
      notifier = function(message, level, opts)
        local message_without_title = message:sub(#"[Neoment] " + 1)
        return Snacks.notify(
          message_without_title,
          vim.tbl_extend("force", opts or {}, {
            title = "Neoment",
            level = level,
          })
        )
      end,
      desktop_notifications = {
        per_room = {
          ["#telegram_vimbr:massolari.us.to"] = "all",
        },
      },
    }
  end,
}
