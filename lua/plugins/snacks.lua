local functions = require("functions")
local quotes = require("data.quotes")

---@param lines string[]
local function add_border(lines)
  local non_empty_lines = vim.tbl_filter(function(line)
    return string.len(line) > 0
  end, lines)

  local bigger_length = math.max(unpack(vim.tbl_map(string.len, non_empty_lines)))

  local lines_bordered = vim.tbl_map(function(line)
    local pad = (bigger_length - string.len(line))
    local format_pattern = ("%s%s%" .. pad .. "s%s")

    return string.format(format_pattern, "│", line, "", "│")
  end, non_empty_lines)

  local horizontal_border = string.rep("─", bigger_length)
  local top_border = ("╭" .. horizontal_border .. "╮")
  local bottom_border = ("╰" .. horizontal_border .. "╯")

  table.insert(lines_bordered, 1, top_border)
  table.insert(lines_bordered, bottom_border)

  return lines_bordered
end

local header_number = functions.get_random(39)

-- Alimenta a semente do gerador de números aleatórios para sortear uma citação aleatória
math.randomseed(os.time())

--- @type LazyPluginSpec
return {
  "folke/snacks.nvim",
  priority = 1000,
  ---@type snacks.Config
  opts = {
    bigfile = { enabled = true },
    dashboard = {
      enabled = true,
      row = 10,
      preset = {
        header = vim.fn.join(
          add_border(
            vim.fn.systemlist("cat " .. vim.fn.stdpath("config") .. "/lua/data/ascii/" .. header_number .. ".cat")
          ),
          "\n"
        ),
        keys = {
          { icon = "  ", desc = "Buscar arquivo", key = "f", action = ":FzfLua files" },
          { icon = "  ", desc = "Arquivos recentes", key = "r", action = ":FzfLua oldfiles" },
          { icon = "󰮗  ", desc = "Procurar nos arquivos", key = "g", action = ":FzfLua live_grep" },
          { icon = "  ", desc = "Octo (Github)", key = "o", action = ":Octo actions" },
          { icon = "󰦨  ", desc = "Feed do dev.to", key = "d", action = ":Devto feed" },
          { icon = "  ", desc = "Novo arquivo", key = "n", action = ":ene!" },
          { icon = " ", key = "q", desc = "Quit", action = ":qa" },
        },
      },
      sections = {
        { section = "header" },
        { section = "keys", gap = 1, padding = 1 },
        { text = functions.get_random_item(quotes), align = "center", padding = { 0, 2 } },
      },
    },
    explorer = { enabled = true, replace_netrw = false },
    git = { enabled = true },
    indent = { enabled = true },
    input = { enabled = true },
    --- @type snacks.image.Config
    image = {
      enabled = true,
      cache = "/tmp",
    },
    lazygit = { enabled = true, configure = true },
    notifier = { enabled = true, top_down = false },
    picker = {
      enabled = true,
      ui_select = false,
    },
    quickfile = { enabled = true },
    rename = { enabled = true },
    scope = { enabled = true },
    terminal = { enabled = true },
    scroll = { enabled = false },
    statuscolumn = { enabled = true },
    words = { enabled = true },
  },
  keys = {
    {
      "<leader>gy",
      function()
        Snacks.lazygit()
      end,
      desc = "Abrir lazygit",
    },
    {
      "<leader>d",
      function()
        Snacks.bufdelete()
      end,
      desc = "Deletar buffer",
    },
    {
      "<leader>E",
      function()
        Snacks.explorer()
      end,
      desc = "Explorador de arquivos",
    },
    {
      "]w",
      function()
        Snacks.words.jump(1, true)
      end,
      desc = "Pr\195\179xima palavra destacada",
    },
    {
      "[w",
      function()
        Snacks.words.jump(-1, true)
      end,
      desc = "Palavra destacada anterior",
    },
    {
      "<leader>t",
      function()
        Snacks.terminal.toggle()
      end,
      desc = "Abrir terminal",
    },
    {
      "<leader>T",
      function()
        Snacks.terminal.toggle(nil, { win = { style = "float" } })
      end,
      desc = "Abrir terminal fluante",
    },
  },
  lazy = false,
}
