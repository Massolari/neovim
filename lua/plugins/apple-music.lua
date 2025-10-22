--- Mostrar todas as funções disponíveis no módulo apple-music
local function apple_music()
  local am = require("apple-music")
  local commands = vim.tbl_keys(am)

  vim.ui.select(commands, { prompt = "Apple Music" }, function(choice)
    if choice then
      am[choice]()
    end
  end)
end

return {
  "p5quared/apple-music.nvim",
  config = true,
  keys = { {
    "<leader>ea",
    apple_music,
    desc = "Apple Music",
  } },
}
