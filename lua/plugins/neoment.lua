local functions = require("functions")
local plugin_dir = vim.g.local_plugins_dir .. "/neoment.nvim"

require("plugins.plenary")

if functions.dir_exists(plugin_dir) then
  vim.cmd.packadd("neoment.nvim")
else
  vim.pack.add({ "https://github.com/Massolari/neoment.nvim" })
end

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
